defmodule GeoDistanceTest do
  use ExUnit.Case
  doctest Distance.Geo

  test "distance between a Point and a Point" do
    assert_in_delta Distance.Geo.distance(%Geo.Point{coordinates: {0, 0}}, %Geo.Point{
                      coordinates: {0.5, 0.5}
                    }),
                    0.707,
                    0.001
  end

  test "distance between a Point and a Point that intersect" do
    assert_in_delta Distance.distance({3, 1}, {3, 1}), 0, 0.001
  end

  # test "distance between a Point and a MultiPoint"
  # test "distance between a Point and a MultiPoint that intersect"
  # test "distance between a Point and a LineString"
  # test "distance between a Point and a LineString that intersect"
  # test "distance between a Point and a MultiLineString"
  # test "distance between a Point and a MultiLineString that intersect"
  # test "distance between a Point and a Polygon"
  # test "distance between a Point and a Polygon that intersect"
  # test "distance between a Point and a MultiPolygon"
  # test "distance between a Point and a MultiPolygon that intersect"

  # test "distance between a MultiPoint and a MultiPoint"
  # test "distance between a MultiPoint and a MultiPoint that intersect"
  # test "distance between a MultiPoint and a LineString"
  # test "distance between a MultiPoint and a LineString that intersect"
  # test "distance between a MultiPoint and a MultiLineString"
  # test "distance between a MultiPoint and a MultiLineString that intersect"
  # test "distance between a MultiPoint and a Polygon"
  # test "distance between a MultiPoint and a Polygon that intersect"
  # test "distance between a MultiPoint and a MultiPolygon"
  # test "distance between a MultiPoint and a MultiPolygon that intersect"

  # test "distance between a LineString and a LineString"
  # test "distance between a LineString and a LineString that intersect"
  # test "distance between a LineString and a MultiLineString"
  # test "distance between a LineString and a MultiLineString that intersect"
  # test "distance between a LineString and a Polygon"
  # test "distance between a LineString and a Polygon that intersect"
  # test "distance between a LineString and a MultiPolygon"
  # test "distance between a LineString and a MultiPolygon that intersect"

  # test "distance between a MultiLineString and a MultiLineString"
  # test "distance between a MultiLineString and a MultiLineString that intersect"
  # test "distance between a MultiLineString and a Polygon"
  # test "distance between a MultiLineString and a Polygon that intersect"
  # test "distance between a MultiLineString and a MultiPolygon"
  # test "distance between a MultiLineString and a MultiPolygon that intersect"

  # test "distance between a Polygon and a Polygon"
  # test "distance between a Polygon and a Polygon that intersect"
  # test "distance between a Polygon and a MultiPolygon"
  # test "distance between a Polygon and a MultiPolygon that intersect"

  # test "distance between a MultiPolygon and a MultiPolygon"
  # test "distance between a MultiPolygon and a MultiPolygon that intersect"
end
