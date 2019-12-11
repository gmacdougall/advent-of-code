require_relative 'point'
require "test/unit"

class TestBlocking < Test::Unit::TestCase
  def test_right
    map = []
    origin = Point.new(map, 0, 0)
    map << origin

    p = Point.new(map, 0, 2)
    map << p
    assert_false(origin.blocked?(p))

    p = Point.new(map, 0, 3)
    map << p
    assert_true(origin.blocked?(p))
  end

  def test_left
    map = []
    origin = Point.new(map, 0, 3)
    map << origin

    p = Point.new(map, 0, 1)
    map << p
    assert_false(origin.blocked?(p))

    p = Point.new(map, 0, 0)
    map << p
    assert_true(origin.blocked?(p))
  end

  def test_down
    map = []
    origin = Point.new(map, 3, 0)
    map << origin

    p = Point.new(map, 1, 0)
    map << p
    assert_false(origin.blocked?(p))

    p = Point.new(map, 0, 0)
    map << p
    assert_true(origin.blocked?(p))
  end

  def test_up
    map = []
    origin = Point.new(map, 0, 0)
    map << origin

    p = Point.new(map, 2, 0)
    map << p
    assert_false(origin.blocked?(p))

    p = Point.new(map, 3, 0)
    map << p
    assert_true(origin.blocked?(p))
  end

  def test_diagonal
    map = []
    origin = Point.new(map, 3, 3)
    map << origin

    p = Point.new(map, 1, 1)
    map << p
    assert_false(origin.blocked?(p))

    p = Point.new(map, 0, 0)
    map << p
    assert_true(origin.blocked?(p))

    p = Point.new(map, 5, 5)
    map << p
    assert_false(origin.blocked?(p))

    p = Point.new(map, 6, 6)
    map << p
    assert_true(origin.blocked?(p))
  end

  def test_knight_diagonal
    map = []
    origin = Point.new(map, 6, 6)
    map << origin

    p = Point.new(map, 2, 4)
    map << p
    assert_false(origin.blocked?(p))

    p = Point.new(map, 0, 3)
    map << p
    assert_true(origin.blocked?(p))

    p = Point.new(map, 10, 8)
    map << p
    assert_false(origin.blocked?(p))

    p = Point.new(map, 12, 9)
    map << p
    assert_true(origin.blocked?(p))
  end
end
