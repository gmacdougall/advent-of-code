#! /usr/bin/env ruby

map, inst = ARGF.read.split("\n\n")

map = map.lines.map(&:chomp)
inst = inst.strip.scan(/\d+[LR]?/)

RANGES = {
  a: { x: 51..100, y: 1..50 },
  b: { x: 51..100, y: 51..100 },
  c: { x: 51..100, y: 101..150 },
  d: { x: 1..50, y: 101..150 },
  e: { x: 1..50, y: 151..200 },
  f: { x: 101..150, y: 1..50 },
}

$no_clip = false

class Node
  attr_reader :x, :y, :type

  def initialize(x, y, type)
    @x = x
    @y = y
    @type = type
    self.class.nodes[[x, y]] = self
  end

  def relative_pos
    "#{x % 50},#{y % 50}"
  end

  def wall?
    @type == '#' && !$no_clip
  end 

  def self.nodes
    @nodes ||= {}
  end

  def range
    RANGES[face]
  end

  def dx
    x - range[:x].min
  end

  def dy
    y - range[:y].min
  end
  
  def face
    RANGES.find do |key, r|
      r[:x].cover?(x) && r[:y].cover?(y)
    end.first
  end

  def find(x, y, dir)
    result = self.class.nodes[[x, y]]
    new_dir = dir
    if !result
      new_x = x
      new_y = y
      case dir
      when :up
        case face
        when :a
          new_x = RANGES[:e][:x].min
          new_y = dx + RANGES[:e][:y].min
          new_dir = :right
        when :d
          new_x = RANGES[:b][:x].min
          new_y = dx + RANGES[:b][:y].min
          new_dir = :right
        when :f
          new_x = dx + RANGES[:e][:x].min
          new_y = RANGES[:e][:y].max
          new_dir = :up
        else
          raise
        end
      when :down
        case face
        when :c
          new_x = RANGES[:e][:x].max
          new_y = dx + RANGES[:e][:y].min
          new_dir = :left
        when :e
          new_x = dx + RANGES[:f][:x].min
          new_y = RANGES[:f][:y].min
          new_dir = :down
        when :f
          new_x = RANGES[:b][:x].max
          new_y = dx + RANGES[:b][:y].min
          new_dir = :left
        else
          raise
        end
      when :left
        case face
        when :a
          new_x = RANGES[:d][:x].min
          new_y = 49 - dy + RANGES[:d][:y].min
          new_dir = :right
        when :b
          new_x = dy + RANGES[:d][:x].min
          new_y = RANGES[:d][:y].min
          new_dir = :down
        when :d
          new_x = RANGES[:a][:x].min
          new_y = 49 - dy + RANGES[:a][:y].min
          new_dir = :right
        when :e
          new_x = dy + RANGES[:a][:x].min
          new_y = RANGES[:a][:y].min
          new_dir = :down
        else
          raise
        end
      when :right
        case face
        when :b, :e
          new_x = dy + RANGES[:f][:x].min
          new_y = RANGES[:f][:y].max
          new_dir = :up
        when :c
          new_x = RANGES[:f][:x].max
          new_y = 49 - dy + RANGES[:f][:y].min
          new_dir = :left
        when :e
          new_x = dy + RANGES[:c][:x].min
          new_y = RANGES[:c][:y].max 
          new_dir = :up
        when :f
          new_x = RANGES[:c][:x].max
          new_y = 49 - dy + RANGES[:c][:y].min
          new_dir = :left
        else
          raise
        end
      end
      result = self.class.nodes[[new_x, new_y]]
      binding.pry if !result
      result
    end

    if result.wall?
      [self, dir]
    else
      [result, new_dir]
    end
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

DIR = %i[
  right
  down
  left
  up
]

def test(start, dir)
  $no_clip = true
  current = Node.nodes[start]
  current_dir = dir

  puts "Starting at #{current.x},#{current.y}, facing #{dir}"
  200.times do
    current, current_dir = current.public_send(current_dir)
    puts "On face #{current.face} at #{current.x},#{current.y}, facing #{current_dir}"
  end

  raise unless [current.x, current.y] == start && dir == current_dir
  puts "ALL GOOD!\n\n\n"
  $no_clip = false
end

RANGES.each do |face, ranges|
  DIR.each do |dir|
    test([ranges[:x].to_a.sample, ranges[:y].to_a.sample], dir)
  end
end

dir_index = 0

current = Node.nodes[[map.first.chars.find_index { _1 == '.' } + 1, 1]]

inst.each do |i|
  num = i.to_i
  turn = i[-1]

  current_dir = DIR[dir_index]

  num.times do
    current, current_dir = current.public_send(current_dir)
  end

  dir_index = DIR.index(current_dir)

  if turn == 'R'
    dir_index += 1
  elsif turn == 'L'
    dir_index -= 1
  end
  dir_index %= 4
end

puts((1000 * current.y) + (4 * current.x) + dir_index)
