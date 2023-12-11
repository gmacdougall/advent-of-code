#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(file)
  file.lines.map { _1.strip.chars }
end

def distance(input, distance)
  x_distances = input.transpose.map { _1.all?('.') ? distance : 1 }
  y_distances = input.map { _1.all?('.') ? distance : 1 }

  input.each_with_index.flat_map do |row, y|
    row.each_with_index.filter_map { |chr, x| [x, y] if chr == '#' }
  end.combination(2).sum do |(ax, ay), (bx, by)|
    x_distances[Range.new(*[ax, bx].sort)].sum + y_distances[Range.new(*[ay, by].sort)].sum - 2
  end
end

if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{distance(input, 2)}"
  puts "Part 2: #{distance(input, 1000000)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(374, distance(parse(File.read('sample')), 2))
  end

  def test_part2
    assert_equal(8410, distance(parse(File.read('sample')), 100))
  end
end
