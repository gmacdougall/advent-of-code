#!/usr/bin/env ruby

map = File.read(ARGV.fetch(0)).strip.split("\n").map(&:chars)
HEIGHT = map.length
WIDTH = map.first.length

class Node
  attr_accessor :door, :key, :distance, :complete, :blocked
  attr_reader :x, :y

  @@all = {}

  def initialize(x, y)
    @x = x
    @y = y
    reset
    @@all[[x, y]] = self
  end

  def self.keys
    all.select(&:key)
  end

  def self.all
    @@all.values
  end

  def self.reset
    all.each(&:reset)
  end

  def reset
    @distance = nil
    @complete = false
    @blocked = []
  end

  def self.draw
    HEIGHT.times do |y|
      WIDTH.times do |x|
        if node = @@all[[x,y]]
          if node.door
            print node.door
          elsif node.key
            print node.key
          elsif node.distance
            print node.distance % 10
          else
            print '.'
          end
        else
          print '#'
        end
      end
      puts
    end
  end

  def up
    @@all[[x, y - 1]]
  end

  def down
    @@all[[x, y + 1]]
  end

  def left
    @@all[[x - 1, y]]
  end

  def right
    @@all[[x + 1, y]]
  end

  def visit_adjacent
    [up, down, left, right].each do |node|
      if node
        if node.distance.nil? || node.distance > self.distance + 1
          node.distance = self.distance + 1
          node.complete = false
          node.blocked = @blocked.dup
          node.blocked << @door if @door
        end
      end
    end
    @complete = true
  end
end

start = nil
map = File.read(ARGV.fetch(0)).strip.split("\n").map(&:chars)
map.each_with_index do |row, y|
  row.each_with_index do |chr, x|
    if chr != '#'
      node = Node.new(x, y)
      node.key = chr if ('a'..'z').include?(chr)
      if ('A'..'Z').include?(chr)
        node.door = chr
        node.blocked << chr
      end
      start = node if chr == '@'
    end
  end
end

start.distance = 0
while node = Node.all.find { |n| n.distance && !n.complete}
  node.visit_adjacent
end

Node.draw

PREREQS = Node.keys.map do |n|
  [n.key, n.blocked.map(&:downcase)]
end.sort.to_h

$distances = {
  '@' => Node.keys.select { |n| n.blocked.empty? }.map { |n| [n.key, n.distance ] }.to_h,
}

Node.keys.each do |s|
  Node.reset
  s.distance = 0
  while node = Node.all.find { |n| n.distance && !n.complete}
    node.visit_adjacent
  end
  $distances[s.key] = Node.keys.map { |n| [n.key, n.distance ] }.to_h
end

available_nodes = PREREQS.select { |_,v| v.empty? }.keys

# I tried things, and gave up.
# This puzzle sucked
