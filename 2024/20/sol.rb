#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, obstacle)
    @x = x
    @y = y
    @obstacle = obstacle
    @visited = nil
    @distance_from_finish = nil
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :distance_from_finish
  attr_accessor :obstacle, :visited

  def self.all = @@all
  def self.find(x, y) = @@all[[x, y]]
  def self.reset = @@all = {}
  def self.reset_visited = @@all.each_value { _1.visited = nil }

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]
  def adjacent = [up, down, left, right].compact.reject { _1.visited || _1.obstacle }
  def assign_distance_from_finish = @distance_from_finish = visited
end

def parse(fname)
  start = nil
  finish = nil
  Node.reset
  File.read(fname).lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |char, x|
      node = Node.new(x, y, char == '#')
      start = node if char == 'S'
      finish = node if char == 'E'
    end
  end
  [start, finish]
end

def compute_distance_from_finish(finish)
  Node.reset_visited
  finish.visited = 0
  to_test = [finish]
  while to_test.any?
    node = to_test.shift
    node.adjacent.each do |dest|
      dest.visited = node.visited + 1
      to_test << dest
    end
  end

  Node.all.each_value(&:assign_distance_from_finish)
end

def go(start, finish, max_cheat, over = 100)
  compute_distance_from_finish(finish)
  Node.reset_visited
  to_test = [start]
  start.visited = 0
  cheats = []
  until finish.visited
    node = to_test.shift
    node.adjacent.each do |dest|
      dest.visited = node.visited + 1
      (-max_cheat..max_cheat).each do |dy|
        (-max_cheat..max_cheat).each do |dx|
          dist = dx.abs + dy.abs
          next unless dist <= max_cheat

          cheat_node = Node.find(node.x + dx, node.y + dy)
          next unless cheat_node
          next if cheat_node.obstacle

          cheat_distance = node.distance_from_finish - dist - cheat_node.distance_from_finish
          cheats << cheat_distance if cheat_distance >= over
        end
      end
      to_test << dest
    end
  end
  cheats.count
end

def part1(start, finish)
  go(start, finish, 2)
end

def part2(start, finish, over = 100)
  go(start, finish, 20, over)
end

if File.exist?('input')
  puts "Part 1: #{part1(*parse('input'))}"
  puts "Part 2: #{part2(*parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    start, finish = parse('sample')
    assert_equal(285, part2(start, finish, 50))
  end
end
