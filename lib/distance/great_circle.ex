defmodule Distance.GreatCircle do
  @moduledoc ~S"""
  Calculate great circle distances (shortest travel distance on the surface of
  a spherical Earth) given a two longitude-latitude pairs.  This is an implementation
  of the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula)
  and approximates using a spherical (non-ellipsoid) Earth with a
  mean radius of 6,371,008.8 meters derived from the WGS84 datum.

  The function accepts two tuples in the form of `{longitude, latitude}` and
  returns the distance in meters. It will also accept a List of tuples.
  """

  @pi_over_180 3.14159265359 / 180.0
  @radius_of_earth_meters 6_371_008.8

  @doc """
  Returns the great circle distance in meters between two points in the form of
  `{longitude, latitude}`.

  ## Examples
      iex> Distance.GreatCircle.distance({-105.343, 39.984}, {-105.534, 39.123})
      97129.22118968463
      iex> Distance.GreatCircle.distance({-74.00597, 40.71427}, {-70.56656, -33.42628})
      8251609.780265334
  """
  def distance({lon1, lat1}, {lon2, lat2}) do
    a = :math.sin((lat2 - lat1) * @pi_over_180 / 2)
    b = :math.sin((lon2 - lon1) * @pi_over_180 / 2)

    s = a * a + b * b * :math.cos(lat1 * @pi_over_180) * :math.cos(lat2 * @pi_over_180)
    2 * :math.atan2(:math.sqrt(s), :math.sqrt(1 - s)) * @radius_of_earth_meters
  end

  @doc """
  Returns the great circle distance in meters along a linestring defined by the
  List of `{longitude, latitude}` pairs.

  ## Examples
      iex> Distance.GreatCircle.distance([
      ...>  {-96.796667, 32.775833},
      ...>  {126.967583, 37.566776},
      ...>  {151.215158, -33.857406},
      ...>  {55.274180, 25.197229},
      ...>  {6.942661, 50.334057},
      ...>  {-97.635926, 30.134442}])
      44728827.84910666
  """
  def distance([]), do: 0
  def distance([_]), do: 0

  def distance([p1, p2 | tail]) do
    distance(p1, p2) + distance([p2 | tail])
  end
end
