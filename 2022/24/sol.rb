#! /usr/bin/env ruby

require 'set'

class Blizzard
  attr_reader :x, :y, :dx, :dy

  def initialize(x, y, dir)
    @x = x
    @y = y
    @dx = 0
    @dy = 0
    case dir
    when '>'
      @dx = 1
    when '<'
      @dx = -1
    when '^'
      @dy = -1
    when 'v'
      @dy = 1
    end
  end

  def move
    @x += dx
    @y += dy

    @x = X_RANGE.max if (x < X_RANGE.min)
    @y = Y_RANGE.max if (y < Y_RANGE.min)

    @x = X_RANGE.min if (x > X_RANGE.max)
    @y = Y_RANGE.min if (y > Y_RANGE.max)
  end
end

class Node
  attr_reader :x, :y, :blizzard_time

  def initialize(x, y)
    @x = x
    @y = y
    @blizzard_time = Set.new
    self.class.nodes[[x, y]] = self
  end

  def self.nodes
    @nodes ||= {}
  end

  def self.find(x, y)
    nodes[[x, y]]
  end

  def find(x, y)
    self.class.find(x, y)
  end

  def up
    find(x, y - 1)
  end

  def down
    find(x, y + 1)
  end

  def left
    find(x - 1, y)
  end

  def right
    find(x + 1, y)
  end

  def possible_moves
    [up, down, left, right, self].compact
  end
end

start = nil
finish = nil
blizzards = []

ARGF.map(&:strip).each_with_index do |row, y|
  row.chars.each_with_index do |val, x|
    next if val == '#'
    blizzards << Blizzard.new(x, y, val) unless val == '.'
    node = Node.new(x, y)
    start ||= node
    finish = node
  end
end

X_RANGE = Range.new(*Node.nodes.keys.map(&:first).minmax)
Y_RANGE = 1..(Node.nodes.keys.map(&:last).max - 1)
LCM = X_RANGE.max.lcm(Y_RANGE.max)

LCM.times do |n|
  blizzards.each do |b|
    Node.find(b.x, b.y).blizzard_time << n
    b.move
  end
end

def bfs(start, finish, time)
  queue = Set.new([start])
  next_queue = Set.new

  while !queue.empty?
    queue.each do |node|
      return time if node == finish

      modded_time = (time + 1) % LCM
      node.possible_moves.each do |a|
        next_queue << a unless a.blizzard_time.include?(modded_time)
      end
    end

    queue = next_queue
    next_queue = Set.new
    time += 1
  end
end

trip1 = bfs(start, finish, 0)
puts "Part 1: #{trip1}"
trip2 = bfs(finish, start, trip1)
trip3 = bfs(start, finish, trip2)
puts "Part 2: #{trip3}"
