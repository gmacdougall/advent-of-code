require_relative '../lib/map'
require 'test/unit'

class TestMap < Test::Unit::TestCase
  def test1
    input = <<~STR
      #######
      #G..#E#
      #E#E.E#
      #G.##.#
      #...#E#
      #...E.#
      #######
    STR

    expected = <<~STR
      #######
      #...#E#   E(200)
      #E#...#   E(197)
      #.E##.#   E(185)
      #E..#E#   E(200), E(200)
      #.....#
      #######
    STR

    map = Map.parse(input)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(37, map.round)
    assert_equal(36334, map.score)
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
      #.E.E.#   E(164), E(197)
      #.#E..#   E(200)
      #E.##.#   E(98)
      #.E.#.#   E(200)
      #...#.#
      #######
    STR

    map = Map.parse(input)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(46, map.round)
    assert_equal(39514, map.score)
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
      #G.G#.#   G(200), G(98)
      #.#G..#   G(200)
      #..#..#
      #...#G#   G(95)
      #...G.#   G(200)
      #######
    STR

    map = Map.parse(input)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(35, map.round)
    assert_equal(27755, map.score)
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
      #.....#
      #.#G..#   G(200)
      #.###.#
      #.#.#.#
      #G.G#G#   G(98), G(38), G(200)
      #######
    STR

    map = Map.parse(input)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(54, map.round)
    assert_equal(28944, map.score)
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
      #.G.....#   G(137)
      #G.G#...#   G(200), G(200)
      #.G##...#   G(200)
      #...##..#
      #.G.#...#   G(200)
      #.......#
      #.......#
      #########
    STR

    map = Map.parse(input)
    while !map.victory?
      map.take_actions
    end
    assert_equal(expected, map.to_s)
    assert_equal(20, map.round)
    assert_equal(18740, map.score)
  end
end
