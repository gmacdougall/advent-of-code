class Point
  attr_reader :x, :y, :asteroid

  def initialize(map, x, y, asteroid = true)
    @map = map
    @x = x
    @y = y
    @asteroid = asteroid
  end

  def to_s
    "#{x},#{y}"
  end

  def distance(target)
    diff(target).map(&:abs).sum
  end

  def blocker(target)
    diff_x, diff_y = diff(target)

    if diff_x == 0
      diff_y = diff_y.positive? ? 1 : -1
    elsif diff_y == 0
      diff_x = diff_x.positive? ? 1 : -1
    else
      r = Rational(diff_x, diff_y)
      diff_x = diff_x.negative? ? -r.numerator.abs : r.numerator.abs
      diff_y = diff_y.negative? ? -r.denominator : r.denominator
    end

    test_x = x + diff_x
    test_y = y + diff_y

    while !(test_x == target.x && test_y == target.y)
      to_vaporize = @map.find { |p| p.x == test_x && p.y == test_y && p.asteroid }
      return to_vaporize if to_vaporize
      test_x += diff_x
      test_y += diff_y
    end

    nil
  end

  def blocked?(target)
    !!blocker(target)
  end

  def vaporize
    puts "Vaporized: #{self}"
    @asteroid = false
    self
  end

  def inspect
    "<Point: x=#{x} y=#{y} asteroid=#{asteroid}>"
  end

  def ratio(station)
    Rational(station.y - y, x - station.x)
  end

  private

  def diff(target)
    [target.x - x, target.y - y]
  end
end
