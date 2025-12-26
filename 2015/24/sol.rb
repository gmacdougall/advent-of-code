#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).scan(/\d+/).map(&:to_i)
end

def solve(weights, groups)
  avg_weight = weights.sum / groups
  (1..).each do |size|
    combos = weights.combination(size).select { _1.sum == avg_weight }
    next if combos.empty?

    return combos.map { it.inject(:*) }.min
  end
end

def part1(weights) = solve(weights, 3)
def part2(weights) = solve(weights, 4)

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(99, part1(parse('sample')))
  end

  def test_part2
    assert_equal(44, part2(parse('sample')))
  end
end
