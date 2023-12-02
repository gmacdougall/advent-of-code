#! /usr/bin/env ruby
# frozen_string_literal: true

LIMITS = {
  red: 12,
  green: 13,
  blue: 14,
}.freeze

def cube_sets(input)
  input.each_line.map do |line|
    game = line.match(/Game (\d+)/)[1].to_i
    results = line
      .scan(/\d+ \w+/)
      .map(&:split)
      .group_by(&:last)
      .map { |color, num| [color.to_sym, num.map { _1.first.to_i }] }
      .to_h
    [game, results]
  end.to_h
end

def part1(input)
  cube_sets(input).filter_map do |game, a|
    game if a.all? { |k, v| v.max <= LIMITS[k] }
  end
end

def part2(input)
  cube_sets(input).values.map do |game|
    game.values.map(&:max).inject(1, :*)
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input')).sum}"
  puts "Part 2: #{part2(File.read('input')).sum}"
end

require 'test/unit'

class MyTest < Test::Unit::TestCase
  def test_part1
    assert_equal([1, 2, 5], part1(File.read('sample')))
  end

  def test_part2
    assert_equal([48, 12, 1560, 630, 36], part2(File.read('sample')))
  end
end
