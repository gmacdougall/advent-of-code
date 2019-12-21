#!/usr/bin/env ruby

class Node
  attr_accessor :portal_dir, :distance, :complete, :outer_portal
  attr_reader :x, :y
  attr_writer :label

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

  def self.reset
    all.values.each(&:reset)
  end

  def label
    return nil unless @label
    @label + (@outer_portal ? 'o' : 'i')
  end

  def reset
    @distance = nil
    @complete = false
  end

  def incomplete?
    !@complete
  end

  def matching_portal_node
    @@all.values.find { |n| n.label == @label  && n.outer_portal != @outer_portal}
  end

  def to_s
    "<x=#{x} y=#{y} label=#{label}>"
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
  label = nil
  portal_dir = nil
  outer_portal = nil

  node_x = x
  node_y = y

  if letters[[x, y + 1]] && Node.all[[x, y + 2]]
    node_y += 2
    label = letter + letters[[x, y + 1]]
    portal_dir = :up
  elsif letters[[x, y - 1]] && Node.all[[x, y - 2]]
    node_y -= 2
    label = letters[[x, y - 1]] + letter
    portal_dir = :down
  elsif letters[[x + 1, y]] && Node.all[[x + 2, y]]
    node_x += 2
    label = letter + letters[[x + 1, y]]
    portal_dir = :left
  elsif letters[[x - 1, y]] && Node.all[[x - 2, y]]
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

    node = Node.all[[node_x, node_y]]
    node.label = label
    node.portal_dir = portal_dir
    node.outer_portal = outer_portal
  end
end

portals = Node.all.values.select(&:label)
distances = portals.map do |portal|
  Node.reset
  portal.distance = 0

  while Node.all.values.any? { |n| n.distance && n.incomplete? }
    node = Node.all.values.select { |n| !n.distance.nil? && n.incomplete? }.min_by(&:distance)
    node.visit_adjacent_no_portals
  end
  [portal.label, Node.all.values.select { |n| n.label && n.distance && n != portal }.map { |n| [n.label, n.distance, n.outer_portal] }]
end.sort.to_h

puts distances.inspect
