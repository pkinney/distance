defmodule Distance.Vincenty do
  @moduledoc ~S"""
  Calculate distance per [Vincenty's inverse formula](https://en.wikipedia.org/wiki/Vincenty%27s_formulae)
  (shortest travel distance on the surface of an [oblate spheroid](https://en.wikipedia.org/wiki/Spheroid#Oblate_spheroids) Earth) given two longitude-latitude pairs.

  This method is iterative and more costly than other methods, such as the [great circle](lib/distance/great_circle.ex) method, but also potentially more accurate.
  It is important to note that [nearly antipodal points](https://en.wikipedia.org/wiki/Vincenty%27s_formulae#Nearly_antipodal_points) can cause convergence issues with this method.

  The function accepts two tuples in the form of `{longitude, latitude}` and
  returns the distance in meters. It will also accept a List of tuples.
  """

  @type coords() :: {number(), number()}

  @convergence_threshold 1.0e-12
  @ellipsoid_flattening 1 / 298.257223563
  @max_iterations 200
  @radians_in_degrees 180 / :math.pi()
  @radius_at_equator 6_378_137
  @radius_at_poles (1 - @ellipsoid_flattening) * @radius_at_equator

  @doc """
  Returns the distance in meters between two points in the form of
  `{longitude, latitude}`, per Vincenty's inverse formula.

  ## Examples
      iex> Distance.Vincenty.distance({-105.343, 39.984}, {-105.534, 39.123})
      96992.65430928342
      iex> Distance.Vincenty.distance({-74.00597, 40.71429}, {-70.56656, -33.42629})
      8216472.876442492
  """

  @spec distance(coords(), coords()) :: float()
  def distance(coord, coord), do: 0.0

  def distance({lon1, lat1}, {lon2, lat2}) do
    u1 = calculate_reduced_latitude(lat1)
    u2 = calculate_reduced_latitude(lat2)
    lambda_initial = degrees_to_radians(lon2 - lon1)

    sin_u1 = :math.sin(u1)
    cos_u1 = :math.cos(u1)
    sin_u2 = :math.sin(u2)
    cos_u2 = :math.cos(u2)

    {_, cos_squared_alpha, sin_sigma, cos_sigma, cos2_sigma_m, sigma} =
      1..@max_iterations
      |> Enum.reduce_while({lambda_initial, 0, 0, 0, 0, 0}, fn _, {lambda_prev, _, _, _, _, _} ->
        sin_lambda = :math.sin(lambda_prev)
        cos_lambda = :math.cos(lambda_prev)
        sin_sigma = calculate_sin_sigma(sin_u1, sin_u2, sin_lambda, cos_u1, cos_u2, cos_lambda)
        cos_sigma = calculate_cos_sigma(sin_u1, sin_u2, cos_u1, cos_u2, cos_lambda)
        sigma = :math.atan2(sin_sigma, cos_sigma)
        sin_alpha = calculate_sin_alpha(cos_u1, cos_u2, sin_lambda, sin_sigma)
        cos_squared_alpha = calculate_cos_squared_alpha(sin_alpha)
        cos2_sigma_m = calculate_cos2_sigma_m(sin_u1, sin_u2, cos_sigma, cos_squared_alpha)
        c = calculate_c(cos_squared_alpha)

        lambda =
          calculate_lambda(
            lambda_initial,
            c,
            sin_alpha,
            sigma,
            sin_sigma,
            cos_sigma,
            cos2_sigma_m
          )

        if abs(lambda - lambda_prev) < @convergence_threshold do
          {:halt, {lambda, cos_squared_alpha, sin_sigma, cos_sigma, cos2_sigma_m, sigma}}
        else
          {:cont, {lambda, cos_squared_alpha, sin_sigma, cos_sigma, cos2_sigma_m, sigma}}
        end
      end)

    u_squared = calculate_u_squared(cos_squared_alpha)
    a = calculate_a(u_squared)
    b = calculate_b(u_squared)
    delta_sigma = calculate_delta_sigma(b, sin_sigma, cos_sigma, cos2_sigma_m)

    @radius_at_poles * a * (sigma - delta_sigma)
  end

  @doc """
  Returns the distance in meters along a linestring defined by the
  List of `{longitude, latitude}` pairs, per Vincenty's inverse formula.

  ## Examples
      iex> Distance.Vincenty.distance([
      ...>  {-96.796667, 32.775833},
      ...>  {126.967583, 37.566776},
      ...>  {151.215158, -33.857406},
      ...>  {55.274180, 25.197229},
      ...>  {6.942661, 50.334057},
      ...>  {-97.635926, 30.134442}])
      44737835.51457705
  """

  @spec distance(list(coords())) :: float()
  def distance([]), do: 0.0
  def distance([_]), do: 0.0

  def distance([p1, p2 | tail]) do
    distance(p1, p2) + distance([p2 | tail])
  end

  @spec degrees_to_radians(number()) :: float()
  defp degrees_to_radians(degrees) do
    degrees / @radians_in_degrees
  end

  @spec calculate_a(number()) :: number()
  defp calculate_a(u_squared) do
    1 + u_squared / 16_384 * (4_096 + u_squared * (-768 + u_squared * (320 - 175 * u_squared)))
  end

  @spec calculate_b(number()) :: number()
  defp calculate_b(u_squared) do
    u_squared / 1_024 * (256 + u_squared * (-128 + u_squared * (74 - 47 * u_squared)))
  end

  @spec calculate_c(number()) :: number()
  defp calculate_c(cos_squared_alpha) do
    @ellipsoid_flattening / 16 * cos_squared_alpha *
      (4 + @ellipsoid_flattening * (4 - 3 * cos_squared_alpha))
  end

  @spec calculate_cos_sigma(number(), number(), number(), number(), number()) :: number()
  defp calculate_cos_sigma(sin_u1, sin_u2, cos_u1, cos_u2, cos_lambda) do
    sin_u1 * sin_u2 + cos_u1 * cos_u2 * cos_lambda
  end

  @spec calculate_cos_squared_alpha(number()) :: number()
  defp calculate_cos_squared_alpha(sin_alpha), do: 1 - :math.pow(sin_alpha, 2)

  @spec calculate_cos2_sigma_m(number(), number(), number(), number()) :: number()
  defp calculate_cos2_sigma_m(_, _, _, 0.0), do: 0

  defp calculate_cos2_sigma_m(sin_u1, sin_u2, cos_sigma, cos_squared_alpha) do
    cos_sigma - 2 * sin_u1 * sin_u2 / cos_squared_alpha
  end

  @spec calculate_delta_sigma(number(), number(), number(), number()) :: number()
  defp calculate_delta_sigma(b, sin_sigma, cos_sigma, cos2_sigma_m) do
    b * sin_sigma *
      (cos2_sigma_m +
         b / 4 *
           (cos_sigma *
              (-1 + 2 * :math.pow(cos2_sigma_m, 2)) -
              b / 6 * cos2_sigma_m *
                (-3 + 4 * :math.pow(sin_sigma, 2)) * (-3 + 4 * :math.pow(cos2_sigma_m, 2))))
  end

  @spec calculate_lambda(number(), number(), number(), number(), number(), number(), number()) ::
          number()
  defp calculate_lambda(lambda_initial, c, sin_alpha, sigma, sin_sigma, cos_sigma, cos2_sigma_m) do
    lambda_initial +
      (1 - c) * @ellipsoid_flattening * sin_alpha *
        (sigma +
           c * sin_sigma *
             (cos2_sigma_m +
                c * cos_sigma *
                  (-1 + 2 * :math.pow(cos2_sigma_m, 2))))
  end

  @spec calculate_reduced_latitude(number()) :: number()
  defp calculate_reduced_latitude(lat) do
    :math.atan((1 - @ellipsoid_flattening) * :math.tan(degrees_to_radians(lat)))
  end

  @spec calculate_sin_alpha(number(), number(), number(), number()) :: number()
  defp calculate_sin_alpha(cos_u1, cos_u2, sin_lambda, sin_sigma) do
    cos_u1 * cos_u2 * sin_lambda / sin_sigma
  end

  @spec calculate_sin_sigma(number(), number(), number(), number(), number(), number()) ::
          number()
  defp calculate_sin_sigma(sin_u1, sin_u2, sin_lambda, cos_u1, cos_u2, cos_lambda) do
    :math.sqrt(
      :math.pow(cos_u2 * sin_lambda, 2) +
        :math.pow(cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda, 2)
    )
  end

  @spec calculate_u_squared(number()) :: number()
  defp calculate_u_squared(cos_squared_alpha) do
    cos_squared_alpha * (:math.pow(@radius_at_equator, 2) - :math.pow(@radius_at_poles, 2)) /
      :math.pow(@radius_at_poles, 2)
  end
end
