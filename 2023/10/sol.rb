#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  attr_reader :type, :x, :y
  attr_accessor :distance

  def initialize(type, x, y)
    @type = type
    @x = x
    @y = y
    @distance = type == 'S' ? 0 : nil

    @@all ||= {}
    @@all[y] ||= {}
    @@all[y][x] = self unless type == '.'
  end

  def self.all_by_distance(distance)
    flat_all.select { _1.distance == distance }
  end

  def self.flat_all
    @@flat_all ||= @@all.values.map(&:values).flatten
  end

  def self.clear
    @@all = {}
    @@flat_all = nil
  end

  def self.find(x, y)
    return nil if x < 0 || y < 0 || !@@all[y]
    @@all[y][x]
  end

  def north
    self.class.find(x, y - 1)
  end

  def south
    self.class.find(x, y + 1)
  end

  def west
    self.class.find(x - 1, y)
  end

  def east
    self.class.find(x + 1, y)
  end

  def restrictive_adjacent
    adjacent.select { |new| new.adjacent.include?(self) }
  end

  def adjacent
    case type
    when '|'
      [north, south]
    when '-'
      [east, west]
    when 'L'
      [north, east]
    when 'J'
      [north, west]
    when '7'
      [south, west]
    when 'F'
      [south, east]
    when '.'
      []
    when 'S'
      [north, south, west, east]
    end.compact
  end
end

def parse(file)
  file.lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |type, x|
      Node.new(type, x, y)
    end
  end
end

def part1
  steps = 0
  loop do
    nodes = Node.all_by_distance(steps)
    nodes.each do |node|
      if node.restrictive_adjacent.all?(&:distance)
        return [node, node.restrictive_adjacent].flatten.map(&:distance).max
      end
      node.restrictive_adjacent.each do |adj|
        adj.distance ||= node.distance + 1
      end
    end
    steps += 1
  end
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 1: #{part1}"
  Node.clear
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse(File.read('sample'))
    assert_equal(8, part1)
    Node.clear
  end
end
