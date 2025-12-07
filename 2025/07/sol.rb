#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, split = false)
    @x = x
    @y = y
    @visited = false
    @beam = false
    @split = split
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :split, :visited

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]]

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]

  def part1
    return if @visited || !down
    @visited = true

    if split
      left.part1
      right.part1
    else
      down.part1
    end
  end

  def part2
    return @cache if @cache
    return 1 unless down

    @cache = if split
      left.part2 + right.part2
    else
      down.part2
    end
  end
end

def parse(fname)
  start = nil
  Node.reset
  File.read(fname).lines(chomp: true).each_with_index.map do |line, y|
    line.chars.each_with_index do |chr, x|
      node = Node.new(x, y, chr == '^')
      start = node if chr == 'S'
    end
  end
  start
end

def part1(node)
  node.part1
  Node.all.each_value.count { it.split && it.visited }
end

def part2(node)
  node.part2
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(21, part1(parse('sample')))
  end

  def test_part2
    assert_equal(40, part2(parse('sample')))
  end
end
