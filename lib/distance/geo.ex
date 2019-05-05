defmodule Distance.Geo do
  @type point :: {number, number}

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
    Enum.map(b, &Distance.distance(&1, a))
    |> Enum.min()
  end

  defp do_distance(%Geo.MultiPoint{coordinates: a}, %Geo.MultiPoint{coordinates: b}) do
    Enum.map(a, fn p1 ->
      Enum.map(b, fn p2 ->
        Distance.distance(p1, p2)
      end)
      |> Enum.min()
    end)
    |> Enum.min()
  end

  defp do_distance(%Geo.Point{} = a, %Geo.LineString{} = b), do: do_distance(b, a)

  defp do_distance(%Geo.LineString{coordinates: a}, %Geo.Point{coordinates: b}) do
    Enum.chunk_every(a, 2, 1, :discard)
    |> Enum.map(fn [p1, p2] ->
      Distance.segment_distance(b, p1, p2)
    end)
    |> Enum.min()
  end

  defp do_distance(%Geo.MultiPoint{} = a, %Geo.LineString{} = b), do: do_distance(b, a)

  defp do_distance(%Geo.LineString{coordinates: a}, %Geo.MultiPoint{coordinates: b}) do
    Enum.map(b, fn p ->
      do_point_linestring_distance(p, a)
    end)
    |> Enum.min()
  end

  defp do_distance(%Geo.Polygon{} = a, %Geo.LineString{} = b), do: do_distance(b, a)

  defp do_distance(%Geo.LineString{coordinates: a}, %Geo.Polygon{coordinates: rings_b}) do
    Enum.map(rings_b, fn b ->
      do_linestring_linestring_distance(a, b)
    end)
    |> Enum.min()
  end

  defp do_distance(%Geo.Polygon{coordinates: rings_a}, %Geo.Polygon{coordinates: rings_b}) do
    Enum.map(rings_a, fn a ->
      Enum.map(rings_b, fn b ->
        do_linestring_linestring_distance(a, b)
      end)
      |> Enum.min()
    end)
    |> Enum.min()
  end

  @spec do_point_linestring_distance(point, list(point)) :: number
  defp do_point_linestring_distance(a, b) do
    b_chunks = Enum.chunk_every(b, 2, 1, :discard)

    Enum.map(b_chunks, fn [b1, b2] ->
      Distance.segment_distance(a, b1, b2)
    end)
    |> Enum.min()
  end

  # Because linear rings duplicate the first point to close, this method can still be used
  # for Polygon distance calculations
  @spec do_linestring_linestring_distance(list(point), list(point)) :: number
  defp do_linestring_linestring_distance(a, b) do
    a_chunks = Enum.chunk_every(a, 2, 1, :discard)
    b_chunks = Enum.chunk_every(b, 2, 1, :discard)

    Enum.map(a_chunks, fn [a1, a2] ->
      Enum.map(b_chunks, fn [b1, b2] ->
        Distance.segment_segment_distance(a1, a2, b1, b2)
      end)
      |> Enum.min()
    end)
    |> Enum.min()
  end
end
