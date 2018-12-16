require_relative '../lib/map'
require 'test/unit'

class TestMap < Test::Unit::TestCase
  def sample_input
    <<~STR
      #########
      #G..G..G#
      #.......#
      #.......#
      #G..E..G#
      #.......#
      #.......#
      #G..G..G#
      #########
    STR
  end

  def battle_input
    <<~STR
      #######
      #.G...#
      #...EG#
      #.#.#G#
      #..G#E#
      #.....#
      #######
    STR
  end

  def test_simple_parse
    expected = <<~STR
      #########
      #G..G..G#   G(200), G(200), G(200)
      #.......#
      #.......#
      #G..E..G#   G(200), E(200), G(200)
      #.......#
      #.......#
      #G..G..G#   G(200), G(200), G(200)
      #########
    STR
    map = Map.parse(sample_input)
    assert_equal(expected, map.to_s)
  end

  def test_movement
    expected = <<~STR
      #########
      #.G...G.#   G(200), G(200)
      #...G...#   G(197)
      #...E..G#   E(200), G(200)
      #.G.....#   G(200)
      #.......#
      #G..G..G#   G(200), G(200), G(200)
      #.......#
      #########
    STR
    map = Map.parse(sample_input)
    map.take_actions
    assert_equal(expected, map.to_s)
  end

  def test_movement_2
    expected = <<~STR
      #########
      #..G.G..#   G(200), G(200)
      #...G...#   G(194)
      #.G.E.G.#   G(200), E(197), G(200)
      #.......#
      #G..G..G#   G(200), G(200), G(200)
      #.......#
      #.......#
      #########
    STR
    map = Map.parse(sample_input)
    2.times { map.take_actions }
    assert_equal(expected, map.to_s)
  end

  def test_movement_3
    expected = <<~STR
      #########
      #.......#
      #..GGG..#   G(200), G(191), G(200)
      #..GEG..#   G(200), E(185), G(200)
      #G..G...#   G(200), G(200)
      #......G#   G(200)
      #.......#
      #.......#
      #########
    STR
    map = Map.parse(sample_input)
    3.times { map.take_actions }
    assert_equal(expected, map.to_s)
  end

  def test_movement_4
    expected = <<~STR
      #########
      #.......#
      #..GGG..#   G(200), G(188), G(200)
      #..GEG..#   G(200), E(173), G(200)
      #G..G...#   G(200), G(200)
      #......G#   G(200)
      #.......#
      #.......#
      #########
    STR
    map = Map.parse(sample_input)
    4.times { map.take_actions }
    assert_equal(expected, map.to_s)
  end

  def test_battle_1
    map = Map.parse(battle_input)
    expected = <<~STR
      #######
      #..G..#   G(200)
      #...EG#   E(197), G(197)
      #.#G#G#   G(200), G(197)
      #...#E#   E(197)
      #.....#
      #######
    STR
    map.take_actions
    assert_equal(expected, map.to_s)

    expected = <<~STR
      #######
      #...G.#   G(200)
      #..GEG#   G(200), E(188), G(194)
      #.#.#G#   G(194)
      #...#E#   E(194)
      #.....#
      #######
    STR
    map.take_actions
    assert_equal(expected, map.to_s)

    expected = <<~STR
      #######
      #...G.#   G(200)
      #..G.G#   G(200), G(131)
      #.#.#G#   G(131)
      #...#E#   E(131)
      #.....#
      #######
    STR
    21.times { map.take_actions }
    assert_equal(expected, map.to_s)

    expected = <<~STR
      #######
      #..G..#   G(200)
      #...G.#   G(131)
      #.#G#G#   G(200), G(128)
      #...#E#   E(128)
      #.....#
      #######
    STR
    map.take_actions
    assert_equal(expected, map.to_s)

    expected = <<~STR
      #######
      #.G...#   G(200)
      #..G..#   G(131)
      #.#.#G#   G(125)
      #..G#E#   G(200), E(125)
      #.....#
      #######
    STR
    map.take_actions
    assert_equal(expected, map.to_s)

    expected = <<~STR
      #######
      #G....#   G(200)
      #.G...#   G(131)
      #.#.#G#   G(122)
      #...#E#   E(122)
      #..G..#   G(200)
      #######
    STR
    map.take_actions
    assert_equal(expected, map.to_s)

    expected = <<~STR
      #######
      #G....#   G(200)
      #.G...#   G(131)
      #.#.#G#   G(119)
      #...#E#   E(119)
      #...G.#   G(200)
      #######
    STR
    map.take_actions
    assert_equal(expected, map.to_s)

    expected = <<~STR
      #######
      #G....#   G(200)
      #.G...#   G(131)
      #.#.#G#   G(116)
      #...#E#   E(113)
      #....G#   G(200)
      #######
    STR
    map.take_actions
    assert_equal(expected, map.to_s)

    expected = <<~STR
      #######
      #G....#   G(200)
      #.G...#   G(131)
      #.#.#G#   G(59)
      #...#.#
      #....G#   G(200)
      #######
    STR
    20.times { map.take_actions }
    assert_equal(expected, map.to_s)

    assert_true(map.victory?)
    assert_equal(27730, map.score)
  end
end
