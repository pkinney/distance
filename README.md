# Distance

[![Build Status](https://travis-ci.org/pkinney/distance.svg?branch=master)](https://travis-ci.org/pkinney/distance)

Provides a set of distance functions for use in GIS or graphic applications.

## Installation

```elixir
defp deps do
  [{:distance, "~> 0.1.2"}]
end
```

## Functions

### Point-Point Distance

Calculate geometric distance between two points (two- or three-dimensional):

```elixir
Distance.distance({2, -1}, {-1, 3}) # => 5
Distance.distance({2, -1, 4}, {-1, 3, 2}) # => 5.385...
```

Calculate the square of the geometric distance between two points (useful as
  a faster way to compare distances between points without the need for an
  expensive square root operation):

```elixir
Distance.distance_squared({2, -1}, {-1, 3}) # => 25
Distance.distance_squared({2, -1, 4}, {-1, 3, 2}) # => 29
```

### Point-Segment Distance

Calculate geometric distance between a point and the closest point on a line
segment.  For instance the distance between the point (3, 3) and the line
segment between (-2, 1) and (5, 3).

```elixir
Distance.segment_distance({3, 2}, {-2, 1}, {5, 3}) # => 0.412...
```

Similar to the distance function, there is a squared version for faster
calculations when needed:

```elixir
Distance.segment_distance_squared({3, 2}, {-2, 1}, {5, 3}) # => 0.170...
```
