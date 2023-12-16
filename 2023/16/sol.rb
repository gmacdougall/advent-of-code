#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  attr_reader :x, :y, :type, :energized

  def initialize(type, x, y)
    @type = type
    @x = x
    @y = y

    @@all ||= {}
    @@all[@y] ||= {}
    @@all[@y][@x] = self
  end

  def self.find(x, y)
    return unless @@all[y]
    @@all[y][x]
  end

  def self.all_nodes = @@all.values.flat_map(&:values)
  def self.clear = @@all = {}

  def reset
    @energized = false
    @done = Set.new
  end

  def up
    return nil if y == 0
    self.class.find(x, y - 1)
  end

  def down
    self.class.find(x, y + 1)
  end

  def left
    return nil if x == 0
    self.class.find(x - 1, y)
  end

  def right
    self.class.find(x + 1, y)
  end

  def self.go(x, y, dir)
    all_nodes.each(&:reset)
    find(x, y).shine(dir)
    all_nodes.count { _1.energized }
  end

  def self.part1
    go(0, 0, :right)
  end

  def self.part2
    @@all.flat_map do |y, col|
      [
        go(0, y, :right),
        go(col.count - 1, y, :left),
        go(y, 0, :down),
        go(y, col.count - 1, :up),
      ]
    end.max
  end

  def shine(dir)
    return if @done.include?(dir)
    @done << dir
    @energized = true
    case type
    when '.'
      public_send(dir)&.shine(dir)
    when '/'
      new_dir = case dir
      when :up
        :right
      when :right
        :up
      when :down
        :left
      when :left
        :down
      end
      public_send(new_dir)&.shine(new_dir)
    when '\\'
      new_dir = case dir
      when :up
        :left
      when :left
        :up
      when :right
        :down
      when :down
        :right
      end
      public_send(new_dir)&.shine(new_dir)
    when '|'
      if dir == :up || dir == :down
        public_send(dir)&.shine(dir)
      else
        public_send(:up)&.shine(:up)
        public_send(:down)&.shine(:down)
      end
    when '-'
      if dir == :up || dir == :down
        public_send(:left)&.shine(:left)
        public_send(:right)&.shine(:right)
      else
        public_send(dir)&.shine(dir)
      end
    end
  end
end

def parse(file)
  file.lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |type, x|
      Node.new(type, x, y)
    end
  end
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 1: #{Node.part1}"
  puts "Part 2: #{Node.part2}"
  Node.clear
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse(File.read('sample'))
    assert_equal(46, Node.part1)
    Node.clear
  end

  def test_part2
    parse(File.read('sample'))
    assert_equal(51, Node.part2)
    Node.clear
  end
end
