defmodule Distance do
  def distance(p1, p2), do: :math.sqrt(distance_squared(p1, p2))
  def segment_distance(p, p1, p2), do: :math.sqrt(segment_distance_squared(p, p1, p2))

  def distance_squared({x1, y1}, {x2, y2}) do
    dx = x1 - x2
    dy = y1 - y2

    dx * dx + dy * dy
  end

  def segment_distance_squared({x, y}, {x1, y1}, {x2, y2}) when x1 == x2 and y1 == y2, do: distance_squared({x, y}, {x1, y1})
  def segment_distance_squared({x, y}, {x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1

    t = ((x - x1) * dx + (y - y1) * dy) / (dx * dx + dy * dy)

    cond do
       (t > 1) -> distance_squared({x, y}, {x2, y2})
       (t > 0) -> distance_squared({x, y}, {x1 + dx * t, y1 + dy * t})
       true -> distance_squared({x, y}, {x1, y1})
    end
  end
end
