#! /usr/bin/env ruby
# frozen_string_literal: true

def part1(str)
  result = []
  chars = str.chars
  while chars.any?
    char = chars.shift

    if char == '('
      first = chars.take_while { it != ?x }.join
      chars.shift(first.length + 1)
      second = chars.take_while { it != ')' }.join
      chars.shift(second.length + 1)

      result << chars.shift(first.to_i).join * second.to_i
    else
      result << char
    end
  end
  result.join.length
end

def part2(str, multiplier = 1)
  len = 0
  chars = str.chars
  while chars.any?
    char = chars.shift

    if char == '('
      first = chars.take_while { it != ?x }.join
      chars.shift(first.length + 1)
      second = chars.take_while { it != ')' }.join
      chars.shift(second.length + 1)

      # Recursion
      len += part2(chars.shift(first.to_i).join, second.to_i)
    else
      len += 1
    end
  end
  len * multiplier
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip)}"
  puts "Part 2: #{part2(File.read('input').strip)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(6, part1('ADVENT'))
    assert_equal(7, part1('A(1x5)BC'))
    assert_equal(9, part1('(3x3)XYZ'))
    assert_equal(11, part1('A(2x2)BCD(2x2)EFG'))
    assert_equal(6, part1('(6x1)(1x3)A'))
    assert_equal(18, part1('X(8x2)(3x3)ABCY'))
  end

  def test_part2
    assert_equal(9, part2('(3x3)XYZ'))
    assert_equal(20, part2('X(8x2)(3x3)ABCY'))
    assert_equal(241_920, part2('(27x12)(20x12)(13x14)(7x10)(1x12)A'))
    assert_equal(445, part2('(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN'))
  end
end
