#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, num)
    @x = x
    @y = y
    @num = num
    @visited = false
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :num
  attr_accessor :visited

  def self.all = @@all
  def self.reset = @@all = {}
  def self.reset_visited = @@all.each_value { _1.visited = false }

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]
  def adjacent = [up, down, left, right].compact.select { _1.num == num + 1 }
end

def parse(fname)
  Node.reset
  File.read(fname).lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |char, x|
      Node.new(x, y, char.to_i)
    end
  end
end

def traverse(start, mark_visited)
  start.adjacent.sum do |node|
    if node.visited
      0
    else
      node.visited = mark_visited
      if node.num == 9
        1
      else
        traverse(node, mark_visited)
      end
    end
  end
end

def part1
  Node.all.values.select { _1.num.zero? }.sum do |head|
    Node.reset_visited
    traverse(head, true)
  end
end

def part2
  Node.all.values.select { _1.num.zero? }.sum do |head|
    Node.reset_visited
    traverse(head, false)
  end
end

if File.exist?('input')
  parse('input')
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse('sample')
    assert_equal(36, part1)
  end

  def test_part2
    parse('sample')
    assert_equal(81, part2)
  end
end
