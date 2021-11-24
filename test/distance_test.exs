defmodule DistanceTest do
  use ExUnit.Case
  use ExUnitProperties

  doctest Distance

  test "calculate distance between two points" do
    assert_in_delta Distance.distance({0, 0}, {0.5, 0.5}), 0.707, 0.001
    assert_in_delta Distance.distance({0, 1}, {1, 0}), 1.414, 0.001
    assert_in_delta Distance.distance({2.5, 2.5}, {4, 0.8}), 2.267, 0.001
    assert_in_delta Distance.distance({2.5, 3.1}, {2.5, 3.1}), 0, 0.001
    assert_in_delta Distance.distance({2, -1}, {-1, 3}), 5, 0.001
  end

  test "calculate distance between multiple points" do
    assert_in_delta Distance.distance([{2.5, 2.5}, {4, 0.8}, {2.5, 3.1}, {2.5, 3.1}]),
                    5.013,
                    0.001

    assert_in_delta Distance.distance([{2.5, 2.5}, {4, 0.8}]), 2.267, 0.001

    assert Distance.distance([{2.5, 3.1}]) == 0
    assert Distance.distance([]) == 0
  end

  test "calculate distance between two 3-dimentional points" do
    assert_in_delta Distance.distance({2, -1, 4}, {-1, 3, 2}), 5.385, 0.001
  end

  test "calculate squared distance between two points" do
    assert Distance.distance_squared({0, 0}, {0.5, 0.5}) == 0.5
    assert Distance.distance_squared({0, 0}, {0.5, 0.5}) == 0.5
    assert Distance.distance_squared({0, 1}, {1, 0}) == 2
    assert Distance.distance_squared({2.5, 2.5}, {4, 0.8}) == 5.14
    assert Distance.distance_squared({2.5, 3.1}, {2.5, 3.1}) == 0
  end

  test "calculate squared distance between two 3-dimentional points" do
    assert_in_delta Distance.distance_squared({2, -1, 4}, {-1, 3, 2}), 29, 0.001
  end

  test "calculate distance between a point and a line segment" do
    assert_in_delta Distance.segment_distance({0.5, 0.5}, {0, 0}, {1, 0}), 0.5, 0.001
    assert_in_delta Distance.segment_distance({0.5, 0.5}, {0, 0}, {-1, 0}), 0.707, 0.001
    assert_in_delta Distance.segment_distance({0.5, 0.5}, {-1, 0}, {0, 0}), 0.707, 0.001
    assert_in_delta Distance.segment_distance({0.5, 0.5}, {0, 0}, {0, 0}), 0.707, 0.001
    assert_in_delta Distance.segment_distance({3, 2}, {-2, 1}, {5, 3}), 0.412, 0.001

    assert_in_delta Distance.segment_distance({7, 1}, {-2, 1}, {5, 1}), 2, 0.001
    assert_in_delta Distance.segment_distance({17, 1}, {-2, 1}, {5, 1}), 12, 0.001
    assert_in_delta Distance.segment_distance({3, 1}, {-2, 1}, {5, 1}), 0, 0.001
    assert_in_delta Distance.segment_distance({-2, 1}, {-2, 1}, {5, 1}), 0, 0.001
    assert_in_delta Distance.segment_distance({5, 1}, {-2, 1}, {5, 1}), 0, 0.001
    assert_in_delta Distance.segment_distance({3, 3}, {-2, 1}, {5, 1}), 2, 0.001
    assert_in_delta Distance.segment_distance({3, -1}, {-2, 1}, {5, 1}), 2, 0.001
    assert_in_delta Distance.segment_distance({-2, -1}, {-2, 1}, {5, 1}), 2, 0.001

    assert_in_delta Distance.segment_distance({7, 1}, {-2, 1}, {-2, 5}), 9, 0.001
    assert_in_delta Distance.segment_distance({17, 1}, {-2, 1}, {-2, 5}), 19, 0.001
    assert_in_delta Distance.segment_distance({-2, 3}, {-2, 1}, {-2, 5}), 0, 0.001
    assert_in_delta Distance.segment_distance({-2, 1}, {-2, 1}, {-2, 5}), 0, 0.001
    assert_in_delta Distance.segment_distance({-2, 5}, {-2, 1}, {-2, 5}), 0, 0.001
    assert_in_delta Distance.segment_distance({3, 3}, {-2, 1}, {-2, 5}), 5, 0.001
    assert_in_delta Distance.segment_distance({2, 1}, {-2, 1}, {-2, 5}), 4, 0.001
    assert_in_delta Distance.segment_distance({-2, -1}, {-2, 1}, {-2, 5}), 2, 0.001

    assert_in_delta Distance.segment_distance({7, 1}, {-2, 1}, {-2, 1}), 9, 0.001
    assert_in_delta Distance.segment_distance({17, 1}, {-2, 1}, {-2, 1}), 19, 0.001
    assert_in_delta Distance.segment_distance({-2, 3}, {-2, 1}, {-2, 1}), 2, 0.001
  end

  test "calculate sqaured distance between a point and a line segment" do
    assert Distance.segment_distance_squared({0.5, 0.5}, {0, 0}, {1, 0}) == 0.5 * 0.5
    assert Distance.segment_distance_squared({0.5, 0.5}, {0, 0}, {-1, 0}) == 0.5
    assert Distance.segment_distance_squared({0.5, 0.5}, {-1, 0}, {0, 0}) == 0.5
    assert Distance.segment_distance_squared({0.5, 0.5}, {0, 0}, {0, 0}) == 0.5

    assert_in_delta Distance.segment_distance_squared({3, 2}, {-2, 1}, {5, 3}), 0.170, 0.001
  end

  test "calculate distance between two disjoint line segments" do
    assert_in_delta Distance.segment_segment_distance({0, 0}, {1, 1}, {1, 0}, {2, 0}),
                    0.707,
                    0.001

    assert_in_delta Distance.segment_segment_distance({0, 0}, {-1, -1}, {3, 4}, {12, 1}),
                    5,
                    0.001
  end

  test "calculate distance between two intersectng line segments" do
    assert Distance.segment_segment_distance({0, 0}, {1, 1}, {0, 1}, {1, 0}) == 0
    assert Distance.segment_segment_distance({0, 0}, {1, 1}, {1, 1}, {1, 0}) == 0
    assert Distance.segment_segment_distance({0, 0}, {1, 1}, {1, 1}, {1, -3}) == 0
    assert Distance.segment_segment_distance({0, 0}, {1, 1}, {0.5, 0.5}, {1, 0}) == 0
  end

  test "project a point a distance along a direction" do
    check all(
            p0 <- {float(min: -100_000, max: 100_000), float(min: -100_000, max: 100_000)},
            distance <- float(min: 0, max: 100_000),
            direction <- float(min: -:math.pi() + 0.00001, max: :math.pi()),
            p1 = Distance.project(p0, direction, distance)
          ) do
      assert_in_delta Distance.distance(p1, p0), distance, 0.00001

      if distance > 0.0 do
        assert_in_delta Distance.angular_difference(Distance.angle_to(p0, p1), direction),
                        0.0,
                        0.00001
      end
    end
  end

  test "determine angle from one point to another" do
    assert Distance.angle_to({2, -1}, {4, -1}) == 0.0
    assert Distance.angle_to({2, -1}, {-1, -1}) == :math.pi()
    assert Distance.angle_to({2, -1}, {2, 5}) == :math.pi() / 2
    assert Distance.angle_to({2, -1}, {2, -2}) == -:math.pi() / 2
  end

  describe "min_coterminal_angle/1" do
    test "handle π and -π corectly" do
      assert Distance.min_coterminal_angle(:math.pi()) == :math.pi()
      assert Distance.min_coterminal_angle(-:math.pi()) == :math.pi()
    end

    test "always returns equivalent angle in the range (-π, π]" do
      check all(angle <- float(min: -100_000, max: 100_000)) do
        coterminal = Distance.min_coterminal_angle(angle)

        assert coterminal <= :math.pi()
        assert coterminal > -:math.pi()
        assert_in_delta :math.cos(coterminal), :math.cos(angle), 0.0001
        assert_in_delta :math.sin(coterminal), :math.sin(angle), 0.0001
      end
    end
  end

  describe "min_positive_coterminal_angle/1" do
    test "handle 0 and 2π corectly" do
      assert Distance.min_positive_coterminal_angle(0.0) == 0.0
      assert Distance.min_positive_coterminal_angle(0) == 0.0
      assert Distance.min_positive_coterminal_angle(2 * :math.pi()) == 0.0
    end

    test "always returns equivalent angle in the range (-π, π]" do
      check all(angle <- float(min: -100_000, max: 100_000)) do
        coterminal = Distance.min_positive_coterminal_angle(angle)

        assert coterminal < 2 * :math.pi()
        assert coterminal >= 0.0
        assert_in_delta :math.cos(coterminal), :math.cos(angle), 0.0001
        assert_in_delta :math.sin(coterminal), :math.sin(angle), 0.0001
      end
    end
  end
end
