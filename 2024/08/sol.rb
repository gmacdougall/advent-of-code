#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  nodes = Hash.new { |h, k| h[k] = [] }
  map = File.read(fname).lines.each_with_index.map do |line, y|
    line.strip.chars.each_with_index.map do |char, x|
      nodes[char] << [x, y] unless char == '.'
      char
    end
  end
  [map, nodes]
end

def tag(map, x, y)
  return unless y.between?(0, map.length - 1) && x.between?(0, map.first.length - 1)

  map[y][x] = '#'
end

def part1(map, nodes)
  nodes.each_value do |values|
    values.combination(2).each do |(x1, y1), (x2, y2)|
      dx = x2 - x1
      dy = y2 - y1
      tag(map, x1 - dx, y1 - dy)
      tag(map, x2 + dx, y2 + dy)
    end
  end
  map.flatten.count { _1 == '#' }
end

def part2(map, nodes)
  nodes.each_value do |values|
    values.combination(2).each do |(x1, y1), (x2, y2)|
      dx = x2 - x1
      dy = y2 - y1
      x = x1
      y = y1
      while tag(map, x, y)
        x -= dx
        y -= dy
      end
      x = x2
      y = y2
      while tag(map, x, y)
        x += dx
        y += dy
      end
    end
  end
  map.flatten.count { _1 == '#' }
end

if File.exist?('input')
  puts "Part 1: #{part1(*parse('input'))}"
  puts "Part 2: #{part2(*parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(14, part1(*parse('sample')))
  end

  def test_part2
    assert_equal(34, part2(*parse('sample')))
  end
end
