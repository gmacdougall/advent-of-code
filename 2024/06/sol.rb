#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, obstacle)
    @x = x
    @y = y
    @obstacle = obstacle
    @@all[[x, y]] = self
  end

  attr_reader :x, :y
  attr_accessor :obstacle

  def self.all = @@all
  def self.reset = @@all = {}

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]
end

def parse(fname)
  Node.reset
  guard = nil
  File.read(fname).lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |char, x|
      node = Node.new(x, y, char == '#')
      guard = node if char == '^'
    end
  end
  guard
end

def part1(guard_node)
  visited = Set.new
  dirs = %i[up right down left]
  while guard_node
    move_to = nil
    loop do
      goto = [guard_node, dirs.first]
      return :blocked if visited.include?(goto)

      visited << goto
      move_to = guard_node.public_send(dirs.first)
      break unless move_to&.obstacle

      dirs.rotate!
    end
    guard_node = move_to
  end
  visited.map(&:first).uniq.size
end

def part2(guard_node)
  Node.all.values.count do |test_node|
    if test_node.obstacle
      false
    else
      test_node.obstacle = true
      result = part1(guard_node)
      test_node.obstacle = false
      result == :blocked
    end
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(41, part1(parse('sample')))
  end

  def test_part2
    assert_equal(6, part2(parse('sample')))
  end
end
