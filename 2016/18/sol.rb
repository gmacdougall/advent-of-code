#! /usr/bin/env ruby
# frozen_string_literal: true

def part1(start, count)
  map = [start.chars.map { it == '^' } ]
  (1...count).each do |n|
    map << (0...start.length).map do |idx|
      left = idx == 0 ? false : map[n - 1][idx - 1]
      centre = map[n - 1][idx]
      right = map[n - 1][idx + 1] || false

      (
        (left && centre && !right) ||
        (centre && right && !left) ||
        (left && !centre && !right) ||
        (right && !left && !centre)
      )
    end
  end
  map.flatten.count { !it }
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip, 40)}"
  puts "Part 2: #{part1(File.read('input').strip, 400000)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(38, part1('.^^.^.^^^^', 10))
  end
end
