#! /usr/bin/env ruby
# frozen_string_literal: true

LIMITS = {
  'red' => 12,
  'green' => 13,
  'blue' => 14,
}.freeze

def cube_sets(input)
  input.lines.map do |line|
    [
      line.match(/Game (\d+)/)[1].to_i,
      line
        .scan(/(\d+) (\w+)/)
        .group_by(&:last)
        .map { |color, num| [color, num.map { _1[0].to_i }.max] }
        .to_h,
    ]
  end.to_h
end

def part1(input)
  input.select { _2.all? { |k, v| v <= LIMITS[k] } }.keys
end

def part2(input)
  input.map { _2.values.inject(1, :*) }
end

if File.exist?('input')
  input = cube_sets(File.read('input'))
  puts "Part 1: #{part1(input).sum}"
  puts "Part 2: #{part2(input).sum}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    cube_sets(File.read('sample'))
  end

  def test_part1
    assert_equal([1, 2, 5], part1(sample))
  end

  def test_part2
    assert_equal([48, 12, 1560, 630, 36], part2(sample))
  end
end
