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
    assert_in_delta Distance.Geo.distance({3, 1}, {3, 1}), 0, 0.001
  end

  test "distance between a Point and a MultiPoint" do
    a = "POINT (86 72)" |> Geo.WKT.decode!()
    b = "MULTIPOINT (20 20, 80 80, 20 120)" |> Geo.WKT.decode!()

    assert_in_delta Distance.Geo.distance(a, b), 10, 0.001
    assert_in_delta Distance.Geo.distance(b, a), 10, 0.001
  end

  test "distance between a Point and a MultiPoint that intersect" do
    a = "POINT (20 120)" |> Geo.WKT.decode!()
    b = "MULTIPOINT (20 20, 80 80, 20 120)" |> Geo.WKT.decode!()

    assert Distance.Geo.distance(a, b) == 0
    assert Distance.Geo.distance(b, a) == 0
  end

  test "distance between a Point and a LineString" do
    a = "LINESTRING(4 8,7 7,8.1 4,8 9,13 10)" |> Geo.WKT.decode!()
    p1 = %Geo.Point{coordinates: {3.7, 7.6}}
    p2 = %Geo.Point{coordinates: {4.7, 7.5}}
    p3 = %Geo.Point{coordinates: {14.5, 8}}

    assert_in_delta Distance.Geo.distance(a, p1), 0.5, 0.001
    assert_in_delta Distance.Geo.distance(p1, a), 0.5, 0.001
    assert_in_delta Distance.Geo.distance(a, p2), 0.253243, 0.001
    assert_in_delta Distance.Geo.distance(p2, a), 0.253243, 0.001
    assert_in_delta Distance.Geo.distance(a, p3), 2.5, 0.001
    assert_in_delta Distance.Geo.distance(p3, a), 2.5, 0.001
  end

  test "distance between a Point and a LineString that intersect" do
    a = "LINESTRING(4 8,7 7,8.1 4,8 9,12 10)" |> Geo.WKT.decode!()
    p1 = %Geo.Point{coordinates: {8.1, 4}}
    p2 = %Geo.Point{coordinates: {10, 9.5}}

    assert Distance.Geo.distance(a, p1) == 0.0
    assert Distance.Geo.distance(p1, a) == 0.0
    assert Distance.Geo.distance(a, p2) == 0.0
    assert Distance.Geo.distance(p2, a) == 0.0
  end

  # test "distance between a Point and a MultiLineString"
  # test "distance between a Point and a MultiLineString that intersect"
  # test "distance between a Point and a Polygon"
  # test "distance between a Point and a Polygon in its hole"
  # test "distance between a Point and a Polygon that intersect"
  # test "distance between a Point and a MultiPolygon"
  # test "distance between a Point and a MultiPolygon that intersect"

  test "distance between a MultiPoint and a MultiPoint" do
    a = "MULTIPOINT(3.2 -7.1,6.5 -1,9 -3,12.03 -1.96)" |> Geo.WKT.decode!()
    b = "MULTIPOINT(2 6,2 -4,12 -2)" |> Geo.WKT.decode!()

    assert_in_delta Distance.Geo.distance(a, b), 0.05, 0.001
    assert_in_delta Distance.Geo.distance(b, a), 0.05, 0.001
  end

  test "distance between a MultiPoint and a MultiPoint that intersect" do
    a = "MULTIPOINT(3.2 -7.1,6.5 -1,9 -3,12.03 -1.96)" |> Geo.WKT.decode!()
    b = "MULTIPOINT(2 6,2 -4,6.5 -1,12 -2)" |> Geo.WKT.decode!()

    assert Distance.Geo.distance(a, b) == 0.0
    assert Distance.Geo.distance(b, a) == 0.0
  end

  test "distance between a MultiPoint and a LineString" do
    a = "LINESTRING(4 8,7 7,8.1 4,8 9,12 10)" |> Geo.WKT.decode!()
    b = "MULTIPOINT(3.7 7.6,4.7 7.5,14.5 8,3.2 -7.1,6.5 -1,9 -3,12.03 -1.96)" |> Geo.WKT.decode!()

    assert_in_delta Distance.Geo.distance(a, b), 0.253243, 0.001
    assert_in_delta Distance.Geo.distance(b, a), 0.253243, 0.001
  end

  test "distance between a MultiPoint and a LineString that intersect" do
    a = "LINESTRING(4 8,7 7,8.1 4,8 9,12 10)" |> Geo.WKT.decode!()

    b =
      "MULTIPOINT(3.7 7.6,4.7 7.5,14.5 8,10 9.5,3.2 -7.1,6.5 -1,9 -3,12.03 -1.96)"
      |> Geo.WKT.decode!()

    assert Distance.Geo.distance(a, b) == 0.0
    assert Distance.Geo.distance(b, a) == 0.0
  end

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
  test "distance between a LineString and a Polygon" do
    a =
      "POLYGON((-5 3,1 -12,12 -2,8 -5,12 4,9 7,9 3,5 7,-1 6,-5 3),(-3 0,2 5,6 3,7 -2,4 0,1 2,-3 0))"
      |> Geo.WKT.decode!()

    b = "LINESTRING(4 8,7 7,8.1 4,8 9,13 10)" |> Geo.WKT.decode!()

    # parallel to polygon edge
    c = "LINESTRING(-4 5,-2.5 6,-4 5.5,-5 5)" |> Geo.WKT.decode!()

    # Inside hole of polygon 
    d = "LINESTRING(0 2,1.5 2.5,3 2)" |> Geo.WKT.decode!()

    assert_in_delta Distance.Geo.distance(a, b), 0.0707106, 0.001
    assert_in_delta Distance.Geo.distance(b, a), 0.0707106, 0.001

    assert_in_delta Distance.Geo.distance(a, c), 0.9, 0.001
    assert_in_delta Distance.Geo.distance(c, a), 0.9, 0.001

    assert_in_delta Distance.Geo.distance(a, d), 0.316227, 0.001
    assert_in_delta Distance.Geo.distance(d, a), 0.316227, 0.001
  end

  test "distance between a LineString and a Polygon that intersect" do
    a =
      "POLYGON((-5 3,1 -12,12 -2,8 -5,12 4,9 7,9 3,5 7,-1 6,-5 3),(-3 0,2 5,6 3,7 -2,4 0,1 2,-3 0))"
      |> Geo.WKT.decode!()

    b = "LINESTRING(-6 -9,5 1,0 12)" |> Geo.WKT.decode!()

    assert Distance.Geo.distance(a, b) == 0.0
    assert Distance.Geo.distance(b, a) == 0.0
  end

  # test "distance between a LineString and a MultiPolygon"
  # test "distance between a LineString and a MultiPolygon that intersect"

  # test "distance between a MultiLineString and a MultiLineString"
  # test "distance between a MultiLineString and a MultiLineString that intersect"
  # test "distance between a MultiLineString and a Polygon"
  # test "distance between a MultiLineString and a Polygon that intersect"
  # test "distance between a MultiLineString and a MultiPolygon"
  # test "distance between a MultiLineString and a MultiPolygon that intersect"

  test "distance between a Polygon and a Polygon" do
    a =
      "POLYGON((-5 3,1 -12,12 -2,8 -5,12 4,9 7,9 3,5 7,-1 6,-5 3),(-3 0,2 5,6 3,7 -2,4 0,1 2,-3 0))"
      |> Geo.WKT.decode!()

    b = "POLYGON((11 -2, 15 -1, 12 1, 11 -2))" |> Geo.WKT.decode!()
    c = "POLYGON((11 -2, 15 -1, 12 1, 11 -2),(12 0,12 -1,13 -0.5,12 0))" |> Geo.WKT.decode!()

    assert_in_delta Distance.Geo.distance(a, b), 0.242535, 0.001
    assert_in_delta Distance.Geo.distance(b, a), 0.242535, 0.001

    assert_in_delta Distance.Geo.distance(a, c), 0.242535, 0.001
    assert_in_delta Distance.Geo.distance(c, a), 0.242535, 0.001
  end

  test "distance between a Polygon and an interior Polygon" do
    a =
      "POLYGON((-5 3,1 -12,12 -2,8 -5,12 4,9 7,9 3,5 7,-1 6,-5 3),(-3 0,2 5,6 3,7 -2,4 0,1 2,-3 0))"
      |> Geo.WKT.decode!()

    b =
      "POLYGON((-4.5 21,-29 -15,17 -17,20 19,-4.5 21),(-8 9,-7 -13,16 -13,14 6,5 17,-8 9))"
      |> Geo.WKT.decode!()

    assert_in_delta Distance.Geo.distance(a, b), 1.0, 0.001
    assert_in_delta Distance.Geo.distance(b, a), 1.0, 0.001
  end

  test "distance between a Polygon and a Polygon that intersect" do
    a =
      "POLYGON((-5 3,1 -12,12 -2,8 -5,12 4,9 7,9 3,5 7,-1 6,-5 3),(-3 0,2 5,6 3,7 -2,4 0,1 2,-3 0))"
      |> Geo.WKT.decode!()

    b = "POLYGON(-10 2, 10 2, 13 -4, -5 -1, -10 2)" |> Geo.WKT.decode!()

    assert Distance.Geo.distance(a, b) == 0.0
    assert Distance.Geo.distance(b, a) == 0.0
  end

  test "distance between a Polygon and a Polygon contained in it" do
    a =
      "POLYGON((-5 3,1 -12,12 -2,8 -5,12 4,9 7,9 3,5 7,-1 6,-5 3),(-3 0,2 5,6 3,7 -2,4 0,1 2,-3 0))"
      |> Geo.WKT.decode!()

    b =
      "POLYGON((-4.5 21,-29 -15,17 -17,20 19,-4.5 21))"
      |> Geo.WKT.decode!()

    assert Distance.Geo.distance(a, b) == 0.0
    assert Distance.Geo.distance(b, a) == 0.0
  end

  # test "distance between a Polygon and a MultiPolygon"
  # test "distance between a Polygon and a MultiPolygon that intersect"

  # test "distance between a MultiPolygon and a MultiPolygon"
  # test "distance between a MultiPolygon and a MultiPolygon that intersect"

  # Inside "POLYGON((-5 3,1 -12,12 -2,8 -5,12 4,9 7,9 3,5 7,-1 6,-5 3),(-3 0,2 5,6 3,7 -2,4 0,1 2,-3 0))"
  # Close Outside LineString, 0.06931089380465308, "LINESTRING(4 8,7 7,8.1 4,8 9,13 10)"
  # Parallel Outside LineString, 1.41421, "LINESTRING(-4 5,-2.5 6,-4 5.5,-5 5)"
  # Inside hole LineString "LINESTRING(0 2,1.5 2.5,3 2)"
  # Interior Point "POINT(3.2 -7.1)"
  # Point in Hole "POINT(6.5 -1)"
  # Point outside "POINT(9 -3)"
  # Point near spike, 0.05, "POINT(12.03 -1.96)"
  # Outside Polygon "POLYGON((-4.5 21,-29 -15,17 -17,20 19,-4.5 21),(-8 9,-7 -13,16 -13,14 6,5 17,-8 9))"
end
