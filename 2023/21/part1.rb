#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

class Node
  attr_reader :x, :y, :garden, :visited

  def initialize(garden, x, y)
    @garden = garden
    @x = x
    @y = y
    @visited = Set.new

    @@all ||= {}
    @@all[@y] ||= {}
    @@all[@y][@x] = self
  end

  def self.all_values
    @@all_values ||= @@all.values.flat_map(&:values)
  end

  def self.find(x, y)
    return unless @@all[y]
    @@all[y][x]
  end

  def self.clear
    @@all = {}
    @@all_values = nil
  end

  def up
    return if y == 0
    self.class.find(x, y - 1)
  end

  def down
    self.class.find(x, y + 1)
  end

  def left
    return if x == 0
    self.class.find(x - 1, y)
  end

  def right
    self.class.find(x + 1, y)
  end

  def adjacent
    @adjacent ||= [up, down, left, right].compact.select(&:garden)
  end

  def self.walk(steps)
    steps.times do |n|
      all_values.select { _1.visited.include?(n) }.each do |dest|
        dest.adjacent.each { _1.visited << n + 1 }
      end
    end
    all_values.count { _1.visited.include?(steps) }
  end
end

def parse(file)
  file.lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |type, x|
      n = Node.new(type != '#', x, y)
      n.visited << 0 if type == 'S'
    end
  end
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 1: #{Node.walk(64)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def setup
    Node.clear
    parse(File.read('sample'))
  end

  def test_part1
    assert_equal(16, Node.walk(6))
  end
end
