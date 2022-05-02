# Distance

[![CI](https://github.com/pkinney/distance/actions/workflows/ci.yaml/badge.svg)](https://github.com/pkinney/distance/actions/workflows/ci.yaml)
[![Hex.pm](https://img.shields.io/hexpm/v/distance.svg)](https://hex.pm/packages/distance)

Provides a set of distance functions for use in GIS or graphic applications.

## Installation

```elixir
defp deps do
  [{:distance, "~> 1.0"}]
end
```

## Functions

### Point-Point Distance

Calculate geometric distance between two or more points (two- or three-dimensional):

```elixir
Distance.distance({2, -1}, {-1, 3}) # => 5
Distance.distance({2, -1, 4}, {-1, 3, 2}) # => 5.385...

Distance.distance([{2.5, 2.5}, {4, 0.8}, {2.5, 3.1}, {2.5, 3.1}]) # => 5.013...
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

### Angular Functions

Get bearing from one point to another and project from one point a given
distance along a direction.  Additionally, there are useful methods for 
simplifying angles to coterminal angles and measuring differences between
directions.

Angles are measured as radians off of the positive x-axis in the direction of
the positive y-axis.


### Great Circle Distance

Calculate great circle distances (shortest travel distance on the surface of
a spherical Earth) given a two longitude-latitude pairs.  This is an implementation
of the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula)
and approximates using a spherical (non-ellipsoid) Earth with a
mean radius of 6,371,008.8 meters derived from the WGS84 datum.

The function accepts two tuples in the form of `{longitude, latitude}` and
returns the distance in meters. It will also accept a List of tuples.

```elixir
Distance.GreatCircle.distance({-96.796667, 32.775833}, {126.967583, 37.566776}) # => 10974882.74...

Distance.GreatCircle.distance([
  {-96.796667, 32.775833},
  {126.967583, 37.566776},
  {151.215158, -33.857406},
  {55.274180, 25.197229},
  {6.942661, 50.334057},
  {-97.635926, 30.134442}
]) # => 44728827.849...
```

### Vincenty's Inverse Formula Distance

Calculate distance per [Vincenty's inverse formula](https://en.wikipedia.org/wiki/Vincenty%27s_formulae)
(shortest travel distance on the surface of an [oblate spheroid](https://en.wikipedia.org/wiki/Spheroid#Oblate_spheroids) Earth) given two longitude-latitude pairs.

This method is iterative and more costly than other methods, such as the [great circle](lib/distance/great_circle.ex) method, but also potentially more accurate. 
It is important to note that [nearly antipodal points](https://en.wikipedia.org/wiki/Vincenty%27s_formulae#Nearly_antipodal_points) can cause convergence issues with this method.

The function accepts two tuples in the form of `{longitude, latitude}` and
returns the distance in meters. It will also accept a List of tuples.

```elixir
Distance.Vincenty.distance({-96.796667, 32.775833}, {126.967583, 37.566776}) # => 10997423.55...

Distance.Vincenty.distance([
  {-96.796667, 32.775833},
  {126.967583, 37.566776},
  {151.215158, -33.857406},
  {55.274180, 25.197229},
  {6.942661, 50.334057},
  {-97.635926, 30.134442}
]) # => 44737835.514...
```
