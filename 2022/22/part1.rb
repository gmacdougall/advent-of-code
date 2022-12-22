#! /usr/bin/env ruby

map, inst = ARGF.read.split("\n\n")

map = map.lines.map(&:chomp)
inst = inst.strip.scan(/\d+[LR]?/)

class Node
  attr_reader :x, :y, :type

  def initialize(x, y, type)
    @x = x
    @y = y
    @type = type
    self.class.nodes[[x, y]] = self
  end

  def wall?
    @type == '#'
  end

  def self.nodes
    @nodes ||= {}
  end

  def find(x, y, dir)
    result = self.class.nodes[[x, y]]
    if !result
      case dir
      when :up
        y = self.class.nodes.keys.select { |nx, ny| nx == x }.map(&:last).max
      when :down
        y = self.class.nodes.keys.select { |nx, ny| nx == x }.map(&:last).min
      when :left
        x = self.class.nodes.keys.select { |nx, ny| ny == y }.map(&:first).max
      when :right
        x = self.class.nodes.keys.select { |nx, ny| ny == y }.map(&:first).min
      end
      result = find(x, y, dir)
    end
    result.wall? ? self : result
  end

  def up
    find(x, y - 1, :up)
  end

  def down
    find(x, y + 1, :down)
  end

  def left
    find(x - 1, y, :left)
  end

  def right
    find(x + 1, y, :right)
  end
end

map.each_with_index do |row, y|
  row.chars.each_with_index do |c, x|
    if c == '.' || c == '#'
      Node.new(x + 1, y + 1, c)
    end
  end
end

dir = %i[
  right
  down
  left
  up
]

current = Node.nodes[[map.first.chars.find_index { _1 == '.' } + 1, 1]]

inst.each do |i|
  num = i.to_i
  turn = i[-1]

  num.times { current = current.public_send(dir.first) }
  dir.rotate!(turn == "R" ? 1 : -1) if turn == 'L' || turn == 'R'
  puts "#{i}: Move #{num} to #{current.x},#{current.y} now facing #{dir.first}"
end

row = current.y
col = current.x

facing = case dir.first
when :right
  0
when :down
  1
when :left
  2
when :up
  3
end

puts((1000 * row) + (4 * col) + facing)
