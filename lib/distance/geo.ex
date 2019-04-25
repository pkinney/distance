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

  defp do_distance(%Geo.MultiPoint{} = a, %Geo.Point{} = b), do: do_distance(b, a)
  defp do_distance(%Geo.Point{coordinates: a}, %Geo.MultiPoint{coordinates: b}) do
    Enum.map(b, &(Distance.distance(&1, a)))
    |> Enum.min
  end
end
