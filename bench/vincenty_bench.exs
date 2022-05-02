defmodule VincentyDistanceBench do
  use Benchfella
  import Distance.Vincenty

  bench "linestring distance" do
    distance([
      {-96.796667, 32.775833},
      {126.967583, 37.566776},
      {151.215158, -33.857406},
      {55.274180, 25.197229},
      {6.942661, 50.334057},
      {-97.635926, 30.134442}
    ])
  end
end
