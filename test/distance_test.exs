defmodule DistanceTest do
  use ExUnit.Case
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
end
