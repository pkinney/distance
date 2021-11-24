defmodule Distance do
  @moduledoc ~S"""
  Basic distance calculations for cartesian coordinates for calculting
  distances on a single plane.  If you are looking to calculating distance
  on the surface of Earth, check out the `Distance.GreatCircle` module.

  ## Examples
      iex> Distance.distance({2.5, 2.5}, {4, 0.8})
      2.2671568097509267
      iex> Distance.segment_distance({2.5, 2.5}, {4, 0.8}, {-2, 3})
      1.0797077632696
      iex> Distance.distance([{2.5, 2.5}, {4, 0.8}, {-2, 3}, {1, -1}])
      13.657774933219109
  """

  @type point() :: {number(), number()}

  @doc """
  Returns the geometric distance between two points.  Accepts 2- or
  3-dimensional points.

  ## Examples
      iex> Distance.distance({1, -2}, {-2, 2})
      5.0
      iex> Distance.distance({1, -2, 2}, {-2, 2, 1})
      5.0990195135927845
  """
  @spec distance(point, point) :: float()
  def distance(p1, p2), do: :math.sqrt(distance_squared(p1, p2))

  @doc """
  Returns the square of the distance between two points.  This is used by the
  `Distance.distance` function above, but having access to the value before
  the expensice sqaure root operation is useful for time-sensitive applications
  that only need values for comparison.

  ## Examples
      iex> Distance.distance_squared({1, -2}, {-2, 2})
      25
      iex> Distance.distance_squared({1, -2, 2}, {-2, 2, 1})
      26
  """
  @spec distance_squared(point, point) :: float()
  def distance_squared({x1, y1}, {x2, y2}) do
    dx = x1 - x2
    dy = y1 - y2

    dx * dx + dy * dy
  end

  def distance_squared({x1, y1, z1}, {x2, y2, z2}) do
    dx = x1 - x2
    dy = y1 - y2
    dz = z1 - z2

    dx * dx + dy * dy + dz * dz
  end

  @doc """
  Returns the geometric distance from a point `p` and the line segment
  between two points `p1` and `p2`.  Note that this is a line segment, not
  an infinite line, so points not between `p1` and `p2` will return the
  distance to the nearest of the two endpoints.

  ## Examples
      iex> Distance.segment_distance({3, 2}, {-2, 1}, {5, 3})
      0.4120816918460673 # distance between the point {3, 2} and the closest point along line segment ({-2, 1}, {5, 3})
      iex> Distance.segment_distance({1, -2}, {-2, 2}, {-10, 102})
      5.0
      iex> Distance.segment_distance({1, -2}, {-2, 2}, {1, -2})
      0.0
  """
  @spec segment_distance(point, point, point) :: float()
  def segment_distance(p, p1, p2), do: :math.sqrt(segment_distance_squared(p, p1, p2))

  @doc """
  Similar to `Distance.distance_squared`, this provides much faster comparable
  version of `Distance.segment_distance`.

  ## Examples
      iex> Distance.segment_distance_squared({3, 2}, {-2, 1}, {5, 3})
      0.16981132075471717
      iex> Distance.segment_distance_squared({1, -2}, {-2, 2}, {-10, 102})
      25
  """
  @spec segment_distance_squared(point, point, point) :: float()
  def segment_distance_squared({x, y}, {x1, y1}, {x2, y2}) when x1 == x2 and y1 == y2,
    do: distance_squared({x, y}, {x1, y1})

  def segment_distance_squared({x, y}, {x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1

    t = ((x - x1) * dx + (y - y1) * dy) / (dx * dx + dy * dy)

    cond do
      t > 1 -> distance_squared({x, y}, {x2, y2})
      t > 0 -> distance_squared({x, y}, {x1 + dx * t, y1 + dy * t})
      true -> distance_squared({x, y}, {x1, y1})
    end
  end

  @doc """
  Provides the minimum distance between any two points along the given line
  segments.  In the case where the segements are not disjoint, this will
  always return `0.0`.

  ## Example
      iex> Distance.segment_segment_distance({0, 0}, {1, 1}, {1, 0}, {2, 0})
      0.7071067811865476
      iex> Distance.segment_segment_distance({0, 0}, {1, 1}, {1, 1}, {2, 2})
      0.0
  """
  @spec segment_segment_distance(point, point, point, point) :: float()
  def segment_segment_distance(a1, a2, b1, b2),
    do: :math.sqrt(segment_segment_distance_squared(a1, a2, b1, b2))

  @doc """
  Similar to `Distance.distance_squared`, this provides much faster comparable
  version of `Distance.segment_segment_distance`.
  """
  @spec segment_segment_distance_squared(point, point, point, point) :: float()
  def segment_segment_distance_squared(a1, a2, b1, b2) do
    case SegSeg.intersection(a1, a2, b1, b2) do
      {true, _, _} ->
        0.0

      {false, _, _} ->
        [
          segment_distance_squared(a1, b1, b2),
          segment_distance_squared(a2, b1, b2),
          segment_distance_squared(b1, a1, a2),
          segment_distance_squared(b2, a1, a2)
        ]
        |> Enum.min()
    end
  end

  @doc """
  Returns the geometric distance of the linestring defined by the List of
  points.  Accepts 2- or 3-dimensional points.

  ## Examples
      iex> Distance.distance([{2.5, 2.5}, {4, 0.8}, {2.5, 3.1}, {2.5, 3.1}])
      5.013062853300123
      iex> Distance.distance([{1, -2, 1}, {-2, 2, -1}, {-2, 1, 0}, {2, -3, 1}])
      12.543941016045627
  """
  @spec distance(list(point)) :: float()
  def distance([]), do: 0.0
  def distance([_]), do: 0.0
  def distance([p1, p2]), do: distance(p1, p2)

  def distance([p1, p2 | tail]) do
    distance(p1, p2) + distance([p2 | tail])
  end

  @doc """
  Returns a point `distance` units away in the direction `direction`.

  The direction is measured as radians off of the positive x-axis in the direction of
  the positive y-axis.  Thus the new coordinates are:

  ```elixir
  x1 = x0 + distance * cos(direction)
  y1 = y0 + distance * sin(direction)
  ```

  ## Examples
      iex> Distance.project({3, 5}, 3 * :math.pi() / 4, 2)
      {1.585786437626905, 6.414213562373095} 
  """
  @spec project(point(), number(), number()) :: point()
  def project({x0, y0}, direction, distance) do
    {
      x0 + distance * :math.cos(direction),
      y0 + distance * :math.sin(direction)
    }
  end

  @doc """
  Returns the direction from p0 to p1.  The direction is
  measured as radians off of the positive x-axis in the direction of the
  positive y-axis.

  The returned value will always be in the range of (-π, π]. The direction 
  along the negative x-axis will always return positive π.

  ## Examples
      iex> Distance.angle_to({2, -1}, {2, 5}) 
      :math.pi() / 2
  """
  @spec angle_to(point(), point()) :: float()
  def angle_to({x0, y0}, {x1, y1}) do
    :math.atan2(y1 - y0, x1 - x0)
  end

  @doc """
  Returns the cotemrinal angle closest to 0 for the given angle

  No matter the angle provided, the returned angle will be in the range (-π, π]

  ## Examples
      iex> Distance.min_coterminal_angle(:math.pi() / 2.0)
      :math.pi() / 2
      iex> Distance.min_coterminal_angle(-2.0 + :math.pi() * 6)
      -2.0
      iex> Distance.min_coterminal_angle(-:math.pi())
      :math.pi()
  """
  @spec min_coterminal_angle(number()) :: float()
  def min_coterminal_angle(angle) do
    :math.pi() - min_positive_coterminal_angle(:math.pi() - angle)
  end

  @doc """
  Returns the minimal positive coterminal angle for the given angle.

  No matter the angle provided, the returned angle will be in the range [0, 2π)


  ## Examples
      iex> Distance.min_positive_coterminal_angle(:math.pi() / 2.0)
      :math.pi() / 2
      iex> Distance.min_positive_coterminal_angle(-2.0 + :math.pi() * 6)
      :math.pi() * 2.0 - 2.0
      iex> Distance.min_positive_coterminal_angle(-:math.pi())
      :math.pi()
  """
  @spec min_positive_coterminal_angle(number()) :: float()
  def min_positive_coterminal_angle(angle) do
    :math.fmod(angle, :math.pi() * 2)
    |> case do
      a when a < 0.0 -> a + :math.pi() * 2
      a -> a
    end
  end

  @doc """
  Returns the angular difference between two directions in the range 
  """
  @spec angular_difference(number(), number()) :: float()
  def angular_difference(a1, a2) do
    min_coterminal_angle(a2 - a1)
  end
end
