#!/usr/bin/env ruby

TOTAL_LEVELS = 100

class Node
  attr_accessor :label, :portal_dir, :distance, :complete, :outer_portal
  attr_reader :x, :y, :level

  @@all = {}

  def initialize(x, y, level)
    @x = x
    @y = y
    @level = level
    @@all[[x, y, level]] = self
  end

  def self.all
    @@all
  end

  def self.draw(level)
    HEIGHT.times do |y|
      WIDTH.times do |x|
        if node = @@all[[x,y,level]]
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

  def self.reset
    all.values.each(&:reset)
  end

  def reset
    @distance = nil
    @complete = false
  end

  def incomplete?
    !@complete
  end

  def matching_portal_node
    result = @@all.values.find { |n| n.label == @label && n.level == portal_level && n.outer_portal != @outer_portal}
    puts result
    result
  end

  def to_s
    "<x=#{x} y=#{y} lvl=#{level} label=#{label}>"
  end

  def up
    if @portal_dir == :up
      matching_portal_node
    else
      @@all[[x, y - 1, @level]]
    end
  end

  def down
    if @portal_dir == :down
      matching_portal_node
    else
      @@all[[x, y + 1, @level]]
    end
  end

  def left
    if @portal_dir == :left
      matching_portal_node
    else
      @@all[[x - 1, y, @level]]
    end
  end

  def right
    if @portal_dir == :right
      matching_portal_node
    else
      @@all[[x + 1, y, @level]]
    end
  end

  def visit_adjacent_no_portals
    [up, down, left, right].reject { |n| n == matching_portal_node }.each do |node|
      if node && node.distance.nil?
        node.distance = @distance + 1
      end
    end
    @complete = true
  end

  def visit_adjacent
    [up, down, left, right].each do |node|
      if node && node.distance.nil?
        node.distance = @distance + 1
      end
    end
    @complete = true
  end

  private

  def portal_level
    @outer_portal ? @level - 1 : @level + 1
  end
end

map = File.read(ARGV.fetch(0)).split("\n").map(&:chars)

HEIGHT = map.length
WIDTH = map[2].length

letters = {}

TOTAL_LEVELS.times do |level|
  map.each_with_index do |row, y|
    row.each_with_index do |chr, x|
      Node.new(x, y, level) if chr == '.'
      if ('A'..'Z').include?(chr)
        letters[[x, y]] = chr
      end
    end
  end
end

letters.each do |key, letter|
  x, y = key
  label = nil
  portal_dir = nil
  outer_portal = nil

  node_x = x
  node_y = y

  if letters[[x, y + 1]] && Node.all[[x, y + 2, 0]]
    node_y += 2
    label = letter + letters[[x, y + 1]]
    portal_dir = :up
  elsif letters[[x, y - 1]] && Node.all[[x, y - 2, 0]]
    node_y -= 2
    label = letters[[x, y - 1]] + letter
    portal_dir = :down
  elsif letters[[x + 1, y]] && Node.all[[x + 2, y, 0]]
    node_x += 2
    label = letter + letters[[x + 1, y]]
    portal_dir = :left
  elsif letters[[x - 1, y]] && Node.all[[x - 2, y, 0]]
    node_x -= 2
    label = letters[[x - 1, y]] + letter
    portal_dir = :right
  end

  if portal_dir
    if (node_x == 2 || node_y == 2 || node_x == WIDTH - 3 || node_y == HEIGHT - 3)
      outer_portal = true
    else
      outer_portal = false
    end

    TOTAL_LEVELS.times do |level|
      node = Node.all[[node_x, node_y, level]]
      node.label = label
      node.portal_dir = portal_dir
      node.outer_portal = outer_portal
    end
  end
end

start = Node.all.values.find { |n| n.label == 'AA' && n.level == 0 }
start.distance = 0

dest = Node.all.values.find { |n| n.label == 'ZZ' && n.level == 0 }

while dest.incomplete?
  node = Node.all.values.select { |n| !n.distance.nil? && n.incomplete? }.min_by(&:distance)
  require 'pry'
  binding.pry unless node
  node.visit_adjacent
end

puts dest.distance
