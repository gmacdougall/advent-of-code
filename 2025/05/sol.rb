#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  ranges, ids = File.read(fname).split("\n\n")

  [
    ranges.lines.map { Range.new(*it.split('-').map(&:to_i)) },
    ids.lines.map(&:to_i)
  ]
end

def part1(ranges, ids)
  ids.count { |id| ranges.any? { _1.cover?(id) } }
end

def part2(ranges, _)
  ranges = ranges.sort_by(&:first)
  total = 0

  range = ranges.shift
  while ranges.any?
    next_range = ranges.shift
    if range.cover?(next_range.first)
      range = (range.first..[range.last, next_range.last].max)
    else
      total += range.size
      range = next_range
    end
  end
  total + range.size
end

if File.exist?('input')
  puts "Part 1: #{part1(*parse('input'))}"
  puts "Part 2: #{part2(*parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(3, part1(*parse('sample')))
  end

  def test_part2
    assert_equal(14, part2(*parse('sample')))
  end
end
