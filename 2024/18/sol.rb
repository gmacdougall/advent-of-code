#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y)
    @x = x
    @y = y
    @visited = nil
    @@all[[x, y]] = self
  end

  attr_reader :x, :y
  attr_accessor :visited

  def self.all = @@all
  def self.reset = @@all = {}
  def self.reset_visited = @@all.each_value { _1.visited = nil }
  def self.find(x, y) = @@all[[x, y]]

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]
  def adjacent = [up, down, left, right].compact
end

def parse(fname, max_size)
  Node.reset

  (0..max_size).each do |x|
    (0..max_size).each do |y|
      Node.new(x, y)
    end
  end

  File.read(fname).scan(/(\d+),(\d+)/).map { _1.map(&:to_i) }.map do |x, y|
    Node.find(x, y)
  end.to_set
end

def part1(blocked)
  Node.reset_visited
  start = Node.all.values.first
  start.visited = 0
  finish = Node.all.values.last

  pq = [start]
  while finish.visited.nil?
    return :impossible if pq.empty?

    node = pq.shift
    node.adjacent.reject(&:visited).each do |dest|
      next if blocked.include?(dest)

      dest.visited = node.visited + 1
      pq << dest
    end
  end
  finish.visited
end

def part2(blocked)
  lower_bound = 0
  upper_bound = blocked.size

  while upper_bound - lower_bound > 1
    size = (lower_bound + upper_bound) / 2
    result = part1(blocked.first(size).to_set)

    if result == :impossible
      upper_bound = size
    else
      lower_bound = size
    end
  end
  result = blocked.to_a[lower_bound]
  "#{result.x},#{result.y}"
end

if File.exist?('input')
  blocked = parse('input', 70)
  puts "Part 1: #{part1(blocked.first(1024))}"
  puts "Part 2: #{part2(blocked)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    blocked = parse('sample', 6)
    assert_equal(22, part1(blocked.first(12)))
  end

  def test_part2
    blocked = parse('sample', 6)
    assert_equal('6,1', part2(blocked))
  end
end
