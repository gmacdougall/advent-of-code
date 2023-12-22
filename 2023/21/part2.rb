#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

class Node
  attr_reader :x, :y
  attr_accessor :at

  def initialize(x, y)
    @x = x
    @y = y
    @at = false

    @@all ||= {}
    @@all[@y] ||= {}
    @@all[@y][@x] = self
  end

  def self.dump
    (0..max_y).each do |y|
      (0..max_x).each do |x|
        node = @@all[y][x]
        if node
          print(node.at ? '▣' : '□')
        else
          print ' '
        end
      end
      puts
    end
    puts "\n"
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

  def self.max_x
    @@max_x ||= all_values.map(&:x).max
  end

  def self.max_y
    @@max_y ||= all_values.map(&:y).max
  end

  def up
    self.class.find(x, y - 1)
  end

  def down
    self.class.find(x, y + 1)
  end

  def left
    self.class.find(x - 1, y)
  end

  def right
    self.class.find(x + 1, y)
  end

  def adjacent
    @adjacent ||= [up, down, left, right].compact
  end

  def self.walk
    goal = Node.find(0, @@all.keys.max / 2)
    loops = 0
    while !goal.at
      to_visit = all_values.select(&:at)
      to_visit.each { _1.at = false }
      to_visit.each do |node|
        node.adjacent.each { _1.at = true }
      end
      loops += 1
    end

    result = 5.times.map do |a|
      y_group = (0 + 131 * a)..(130 + 131 * a)
      5.times.map do |b|
        x_group = (0 + 131 * b)..(130 + 131 * b)
        Node.all_values.select { x_group.include?(_1.x) && y_group.include?(_1.y) }.count(&:at)
      end
    end

    top = result[0][2]
    left = result[2][0]
    right = result[2][4]
    bottom = result[4][2]
    top_left_small = result[0][1]
    top_right_small = result[0][3]
    bottom_left_small = result[4][1]
    bottom_right_small = result[4][3]
    top_left_big = result[1][1]
    top_right_big = result[1][3]
    bottom_left_big = result[3][1]
    bottom_right_big = result[3][3]

    odd = result[2][2]
    even = result[2][1]
    counts = [odd, even]

    grid_steps = ((26_501_365 - 65) / 131)

    # The starting square is the start value
    total = grid_steps.times.inject(odd) do |sum, n|
      sum + ((4 * n)) * counts[n % 2]
    end +
      ((top_left_small + top_right_small + bottom_left_small + bottom_right_small) * grid_steps) +
      ((top_left_big + top_right_big + bottom_left_big + bottom_right_big) * (grid_steps - 1)) +
      (top + left + bottom + right)

    puts "Part 2: #{total}"
  end
end

def parse(file)
  input = file.lines
  input = input.map { _1.strip * 5 }
  input *= 5

  input.each_with_index do |line, y|
    line.strip.chars.each_with_index do |type, x|
      next if type == '#'
      n = Node.new(x, y)
    end
  end

  Node.find(input.count / 2, input.count / 2).at = true
end

parse(File.read('input'))
Node.walk
