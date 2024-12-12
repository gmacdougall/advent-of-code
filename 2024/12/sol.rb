#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, type)
    @x = x
    @y = y
    @type = type
    @visited = false
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :type
  attr_accessor :visited

  def self.all = @@all
  def self.reset = @@all = {}
  def self.reset_visited = @@all.each_value { _1.visited = false }

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]
  def adjacent = [up, down, left, right]

  def adjacent_group
    return [] if visited

    @visited = true
    [self] + adjacent.compact.select { _1.type == @type }.flat_map(&:adjacent_group)
  end

  def num_fences
    adjacent.count do |adj|
      adj.nil? || adj.type != type
    end
  end

  def up_fence = [x...(x + 1), y - 0.1]
  def down_fence = [x...(x + 1), y + 0.1]
  def left_fence = [x - 0.1, y...(y + 1)]
  def right_fence = [x + 0.1, y...(y + 1)]

  def fence_edges
    %i[up down left right].map do |dir|
      (public_send(dir).nil? || public_send(dir).type != type) && public_send("#{dir}_fence".to_sym)
    end.compact
  end
end

def parse(fname)
  Node.reset
  File.read(fname).lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |char, x|
      Node.new(x, y, char)
    end
  end
end

def part1
  Node.all.values.sum do |node|
    if node.visited
      0
    else
      group = node.adjacent_group
      group.size * group.sum(&:num_fences)
    end
  end
end

def num_sides(group)
  fence_edges = group.map(&:fence_edges).flatten(1)

  all_edges =
    fence_edges.select { |x, _y| x.is_a?(Float) }.group_by(&:first).values +
    fence_edges.select { |_x, y| y.is_a?(Float) }.group_by(&:last).values

  all_edges.reduce(0) do |result, same_x|
    ranges = same_x.flatten.select { _1.is_a?(Range) }.sort_by(&:first)

    while ranges.size >= 2
      r1 = ranges.pop
      r2 = ranges.pop

      if r2.last == r1.first
        ranges.push r2.first...r1.last
      else
        result += 1
        ranges.push r2
      end
    end
    result + 1
  end
end

def part2
  Node.all.values.sum do |node|
    if node.visited
      0
    else
      group = node.adjacent_group
      group.size * num_sides(group)
    end
  end
end

if File.exist?('input')
  parse('input')
  puts "Part 1: #{part1}"
  parse('input')
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1_sample1
    parse('sample')
    assert_equal(140, part1)
  end

  def test_part1_sample2
    parse('sample2')
    assert_equal(1930, part1)
  end

  def test_part2_sample3
    parse('sample3')
    assert_equal(236, part2)
  end

  def test_part2_sample2
    parse('sample2')
    assert_equal(1206, part2)
  end

  def test_part2_sample4
    parse('sample4')
    assert_equal(368, part2)
  end
end
