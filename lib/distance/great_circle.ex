defmodule Distance.GreatCircle do
  @pi_over_180 3.14159265359 / 180.0
  @radius_of_earth_meters 6_371_008.8

  def distance({lon1, lat1}, {lon2, lat2}) do
    a = :math.sin((lat2 - lat1) * @pi_over_180 / 2)
    b = :math.sin((lon2 - lon1) * @pi_over_180 / 2)

    s = a * a + b * b * :math.cos(lat1 * @pi_over_180) * :math.cos(lat2 * @pi_over_180)
    2 * :math.atan2(:math.sqrt(s), :math.sqrt(1 - s)) * @radius_of_earth_meters
  end

  def distance([]), do: 0
  def distance([_]), do: 0
  def distance([p1, p2]), do: distance(p1, p2)
  def distance([p1, p2 | tail]) do
    distance(p1, p2) + distance([ p2 | tail])
  end
end
