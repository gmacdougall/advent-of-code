#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y)
    @x = x
    @y = y
    @distance = nil
    @@all[[x, y]] = self
  end

  attr_reader :x, :y
  attr_accessor :distance

  def self.all = @@all
  def self.reset(fav_num)
    @@all = {}
    @@fav_num = fav_num
  end
  def self.find(x, y)
    return nil if x.negative? || y.negative?
    @@all[[x, y]] || Node.new(x, y)
  end

  def up = self.class.find(x, y - 1)
  def down = self.class.find(x, y + 1)
  def left = self.class.find(x - 1, y)
  def right = self.class.find(x + 1, y)

  def adjacent = [up, down, left, right].compact.reject(&:blocked?)
  def blocked?
    num = x*x + 3*x + 2*x*y + y + y*y + @@fav_num
    num.to_s(2).chars.tally['1'].odd?
  end
end

def part1(x, y)
  start = Node.find(1, 1)
  dest = Node.find(x, y)
  start.distance = 0
  queue = [start]

  while !dest.distance
    node = queue.shift
    node.adjacent.each do |adj|
      next if adj.distance
      adj.distance = node.distance + 1
      queue << adj
    end
  end
  dest.distance
end

def part2
  start = Node.find(1, 1)
  start.distance = 0
  queue = [start]
  count = 0

  loop do
    node = queue.shift
    break if node.distance > 50

    node.adjacent.each do |adj|
      next if adj.distance
      adj.distance = node.distance + 1
      queue << adj
      count += 1
    end
  end
  count
end

require 'minitest/autorun'

Node.reset(1350)
puts "Part 1: #{part1(31, 39)}"
Node.reset(1350)
puts "Part 2: #{part2}"

class MyTest < Minitest::Test
  def test_part1
    Node.reset(10)
    assert_equal(11, part1(7, 4))
  end
end
