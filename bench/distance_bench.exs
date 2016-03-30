defmodule DistanceBench do
  use Benchfella
  import Distance

  bench "linestring distance" do
    Distance.distance([{2.5, 2.5}, {4, 0.8}, {2.5, 3.1}, {2.5, 3.1}])
  end
end
