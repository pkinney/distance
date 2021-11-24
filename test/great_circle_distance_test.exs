defmodule GreatCircleDistanceTest do
  use ExUnit.Case
  doctest Distance.GreatCircle
  alias Distance.GreatCircle

  test "calculate great circle distance between two points" do
    assert GreatCircle.distance({-74.00597, 40.71427}, {-74.00597, 40.71427}) == 0
    assert_in_delta GreatCircle.distance({-180, 40.71427}, {180, 40.71427}), 0, 0.1
    assert_in_delta GreatCircle.distance({-180, 0}, {180, 0}), 0, 0.1
    assert_in_delta GreatCircle.distance({-142, 90}, {26, 90}), 0, 0.1

    assert_in_delta GreatCircle.distance({-142, 90}, {26, -90}),
                    6_371_008.8 * :math.pi(),
                    1

    assert_in_delta GreatCircle.distance({-90, 0}, {90, 0}),
                    6_371_008.8 * :math.pi(),
                    1

    assert_in_delta GreatCircle.distance({-180, 0}, {0, 0}),
                    6_371_008.8 * :math.pi(),
                    1

    assert_in_delta GreatCircle.distance(
                      {-96.796667, 32.775833},
                      {126.967583, 37.566776}
                    ),
                    10_974_883,
                    1

    assert_in_delta GreatCircle.distance(
                      {126.967583, 37.566776},
                      {151.215158, -33.857406}
                    ),
                    8_328_610,
                    1

    assert_in_delta GreatCircle.distance(
                      {151.215158, -33.857406},
                      {55.274180, 25.197229}
                    ),
                    12_048_941,
                    1

    assert_in_delta GreatCircle.distance({55.274180, 25.197229}, {6.942661, 50.334057}),
                    4_962_217,
                    1

    assert_in_delta GreatCircle.distance({6.942661, 50.334057}, {-97.635926, 30.134442}),
                    8_414_177,
                    1

    assert_in_delta GreatCircle.distance({-90, 30}, {-87, 32}), 362_210, 1
    assert_in_delta GreatCircle.distance({-75.343, 39.984}, {-75.534, 39.123}), 97_129, 1
    assert_in_delta GreatCircle.distance({-130, 42}, {130, -42}), 13_669_374, 1

    assert_in_delta GreatCircle.distance({-74.00597, 40.71427}, {-70.56656, -33.42628}),
                    8_251_609,
                    1
  end

  test "calculate great circle distance along a list of points" do
    assert_in_delta GreatCircle.distance([
                      {-96.796667, 32.775833},
                      {126.967583, 37.566776},
                      {151.215158, -33.857406},
                      {55.274180, 25.197229},
                      {6.942661, 50.334057},
                      {-97.635926, 30.134442}
                    ]),
                    10_974_883 + 8_328_610 + 12_048_941 + 4_962_217 + 8_414_177,
                    10
  end

  test "calculate the distance for two points in a list" do
    assert_in_delta GreatCircle.distance([
                      {-96.796667, 32.775833},
                      {126.967583, 37.566776}
                    ]),
                    10_974_883,
                    1
  end

  test "calculate 0 as the distance for one point" do
    assert GreatCircle.distance([{-96.796667, 32.775833}]) == 0
  end

  test "calculate 0 as the distance for no points" do
    assert GreatCircle.distance([]) == 0
  end
end
