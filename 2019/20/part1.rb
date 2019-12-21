#!/usr/bin/env ruby

class Node
  attr_accessor :label, :portal_dir, :distance, :complete
  attr_reader :x, :y

  @@all = {}

  def initialize(x, y)
    @x = x
    @y = y
    @@all[[x, y]] = self
  end

  def self.all
    @@all
  end

  def self.draw
    HEIGHT.times do |y|
      WIDTH.times do |x|
        if node = @@all[[x,y]]
          if node.distance
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

  def incomplete?
    !@complete
  end

  def matching_portal_node
    @@all.values.find { |n| n.label == @label && n != self }
  end

  def up
    if @portal_dir == :up
      matching_portal_node
    else
      @@all[[x, y - 1]]
    end
  end

  def down
    if @portal_dir == :down
      matching_portal_node
    else
      @@all[[x, y + 1]]
    end
  end

  def left
    if @portal_dir == :left
      matching_portal_node
    else
      @@all[[x - 1, y]]
    end
  end

  def right
    if @portal_dir == :right
      matching_portal_node
    else
      @@all[[x + 1, y]]
    end
  end

  def visit_adjacent
    [up, down, left, right].each do |node|
      if node && node.distance.nil?
        node.distance = @distance + 1
      end
    end
    @complete = true
  end
end

map = File.read(ARGV.fetch(0)).split("\n").map(&:chars)

HEIGHT = map.length
WIDTH = map[2].length

letters = {}

map.each_with_index do |row, y|
  row.each_with_index do |chr, x|
    Node.new(x, y) if chr == '.'
    if ('A'..'Z').include?(chr)
      letters[[x, y]] = chr
    end
  end
end

letters.each do |key, letter|
  x, y = key
  if letters[[x, y + 1]] && node = Node.all[[x, y + 2]]
    node.label = letter + letters[[x, y + 1]]
    node.portal_dir = :up
  elsif letters[[x, y - 1]] && node = Node.all[[x, y - 2]]
    node.label = letters[[x, y - 1]] + letter
    node.portal_dir = :down
  elsif letters[[x + 1, y]] && node = Node.all[[x + 2, y]]
    node.label = letter + letters[[x + 1, y]]
    node.portal_dir = :left
  elsif letters[[x - 1, y]] && node = Node.all[[x - 2, y]]
    node.label = letters[[x - 1, y]] + letter
    node.portal_dir = :right
  end
end

start = Node.all.values.find { |n| n.label == 'AA' }
start.distance = 0

while Node.all.values.any?(&:incomplete?)
  node = Node.all.values.select { |n| !n.distance.nil? && n.incomplete? }.min_by(&:distance)
  node.visit_adjacent
end

Node.draw

puts Node.all.values.find { |n| n.label == 'ZZ' }.distance
