defmodule VincentyDistanceTest do
  use ExUnit.Case
  doctest Distance.Vincenty
  alias Distance.Vincenty

  test "calculate Vincenty inverse formula distance between two points" do
    assert Vincenty.distance({-74.00597, 40.71427}, {-74.00597, 40.71427}) == 0
    assert_in_delta Vincenty.distance({-180, 40.71427}, {180, 40.71427}), 0, 0.1
    assert_in_delta Vincenty.distance({-180, 0}, {180, 0}), 0, 0.1
    assert_in_delta Vincenty.distance({-142, 90}, {26, 90}), 0, 0.1

    assert_in_delta Vincenty.distance(
                      {-96.796667, 32.775833},
                      {126.967583, 37.566776}
                    ),
                    10_997_423,
                    1

    assert_in_delta Vincenty.distance(
                      {126.967583, 37.566776},
                      {151.215158, -33.857406}
                    ),
                    8_296_608,
                    1

    assert_in_delta Vincenty.distance(
                      {151.215158, -33.857406},
                      {55.274180, 25.197229}
                    ),
                    12_044_003,
                    1

    assert_in_delta Vincenty.distance({55.274180, 25.197229}, {6.942661, 50.334057}),
                    4_967_364,
                    1

    assert_in_delta Vincenty.distance({6.942661, 50.334057}, {-97.635926, 30.134442}),
                    8_432_435,
                    1

    assert_in_delta Vincenty.distance({-90, 30}, {-87, 32}), 362_264, 1
    assert_in_delta Vincenty.distance({-75.343, 39.984}, {-75.534, 39.123}), 96_992, 1
    assert_in_delta Vincenty.distance({-130, 42}, {130, -42}), 13_655_805, 1

    assert_in_delta Vincenty.distance({-74.00597, 40.71427}, {-70.56656, -33.42628}),
                    8_216_469,
                    1
  end

  test "calculate Vincenty inverse formula distance along a list of points" do
    assert_in_delta Vincenty.distance([
                      {-96.796667, 32.775833},
                      {126.967583, 37.566776},
                      {151.215158, -33.857406},
                      {55.274180, 25.197229},
                      {6.942661, 50.334057},
                      {-97.635926, 30.134442}
                    ]),
                    10_997_423 + 8_296_608 + 12_044_003 + 4_967_364 + 8_432_435,
                    3
  end

  test "calculate the distance for two points in a list" do
    assert_in_delta Vincenty.distance([
                      {-96.796667, 32.775833},
                      {126.967583, 37.566776}
                    ]),
                    10_997_423,
                    1
  end

  test "calculate 0 as the distance for one point" do
    assert Vincenty.distance([{-96.796667, 32.775833}]) == 0
  end

  test "calculate 0 as the distance for no points" do
    assert Vincenty.distance([]) == 0
  end
end
