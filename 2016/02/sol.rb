#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).map(&:chars)
end

PART1 = [
  %w[1 2 3],
  %w[4 5 6],
  %w[7 8 9],
].freeze

PART2 = [
  [nil, nil, '1', nil, nil],
  [nil, '2', '3', '4', nil],
  ['5', '6', '7', '8', '9'],
  [nil, 'A', 'B', 'C', nil],
  [nil, nil, 'D', nil, nil],
]


DIR = {
  'U' => [0, -1],
  'D' => [0, 1],
  'L' => [-1, 0],
  'R' => [1, 0],
}

def part1(input)
  x = y = 1
  str = ""
  input.each do |line|
    line.each do |chr|
      dx, dy = DIR[chr]
      x = (x + dx).clamp(0..2)
      y = (y + dy).clamp(0..2)
    end
    str += PART1[y][x]
  end
  str
end

def part2(input)
  x, y = 0, 2
  str = ""
  input.each do |line|
    line.each do |chr|
      dx, dy = DIR[chr]
      nx = (x + dx)
      ny = (y + dy)
      if nx >= 0 && ny >= 0 && PART2[ny] && PART2[ny][nx]
        x, y = nx, ny
      end
    end
    str += PART2[y][x]
  end
  str
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal('1985', part1(parse('sample')))
  end

  def test_part2
    assert_equal('5DB3', part2(parse('sample')))
  end
end
