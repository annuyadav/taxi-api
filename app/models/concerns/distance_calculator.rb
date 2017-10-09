module DistanceCalculator
  def distance_between(x1, y1, x2, y2)
    ((x2 - x1)**2 + (y2 - y1)**2)**(0.5)
  end
end