#! /usr/bin/env ruby
# frozen_string_literal: true

def area(str)
  sides = str.split('x').map(&:to_i)
  sides.combination(2).sum { 2 * _1 * _2 } + sides.sort.first(2).inject(:*)
end

def ribbon(str)
  sides = str.split('x').map(&:to_i)
  sides.inject(:*) + sides.sort.first(2).sum { 2 * _1 }
end

def part1(input) = input.lines.sum { area it }
def part2(input) = input.lines.sum { ribbon it }

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input'))}"
  puts "Part 2: #{part2(File.read('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(58, area('2x3x4'))
    assert_equal(43, area('1x1x10'))
  end

  def test_part1
    assert_equal(34, ribbon('2x3x4'))
    assert_equal(14, ribbon('1x1x10'))
  end
end
