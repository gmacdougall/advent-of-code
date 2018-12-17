require_relative '../lib/map'
require 'test/unit'

class TestPart2 < Test::Unit::TestCase
  def test1
    input = <<~STR
      #######
      #.G...#
      #...EG#
      #.#.#G#
      #..G#E#
      #.....#
      #######
    STR

    expected = <<~STR
      #######
      #..E..#   E(158)
      #...E.#   E(14)
      #.#.#.#
      #...#.#
      #.....#
      #######
    STR

    map = Map.parse(input, 15)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(29, map.round)
    assert_equal(4988, map.score)
  end

  def test2
    input = <<~STR
      #######
      #E..EG#
      #.#G.E#
      #E.##E#
      #G..#.#
      #..E#.#
      #######
    STR

    expected = <<~STR
      #######
      #.E.E.#   E(200), E(23)
      #.#E..#   E(200)
      #E.##E#   E(125), E(200)
      #.E.#.#   E(200)
      #...#.#
      #######
    STR

    map = Map.parse(input, 4)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(33, map.round)
    assert_equal(31284, map.score)
  end

  def test3
    input = <<~STR
      #######
      #E.G#.#
      #.#G..#
      #G.#.G#
      #G..#.#
      #...E.#
      #######
    STR

    expected = <<~STR
      #######
      #.E.#.#   E(8)
      #.#E..#   E(86)
      #..#..#
      #...#.#
      #.....#
      #######
    STR

    map = Map.parse(input, 15)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(37, map.round)
    assert_equal(3478, map.score)
  end

  def test4
    input = <<~STR
      #######
      #.E...#
      #.#..G#
      #.###.#
      #E#G#G#
      #...#G#
      #######
    STR

    expected = <<~STR
      #######
      #...E.#   E(14)
      #.#..E#   E(152)
      #.###.#
      #.#.#.#
      #...#.#
      #######
    STR

    map = Map.parse(input, 12)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(39, map.round)
    assert_equal(6474, map.score)
  end

  def test5
    input = <<~STR
      #########
      #G......#
      #.E.#...#
      #..##..G#
      #...##..#
      #...#...#
      #.G...G.#
      #.....G.#
      #########
    STR

    expected = <<~STR
      #########
      #.......#
      #.E.#...#   E(38)
      #..##...#
      #...##..#
      #...#...#
      #.......#
      #.......#
      #########
    STR

    map = Map.parse(input, 34)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(30, map.round)
    assert_equal(1140, map.score)
  end
end
