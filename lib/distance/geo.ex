defmodule Distance.Geo do

  @type geometry ::
      %Geo.Point{}
      | %Geo.MultiPoint{}
      | %Geo.LineString{}
      | %Geo.MultiLineString{}
      | %Geo.Polygon{}
      | %Geo.MultiPolygon{}

  @spec distance(geometry, geometry) :: number
  def distance(a, b) do
    case Topo.intersects?(a, b) do
      true -> 0.0
      false -> do_distance(a, b)
    end
  end

  defp do_distance(%Geo.Point{coordinates: a}, %Geo.Point{coordinates: b}) do
    Distance.distance(a, b)
  end
end
