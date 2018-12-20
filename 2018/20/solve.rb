#!/usr/bin/env ruby

LOOKUP = {
  'N' => :north,
  'E' => :east,
  'W' => :west,
  'S' => :south,
}

OPPOSITE = {
  north: :south,
  west: :east,
  east: :west,
  south: :north,
}

class Room
  attr_accessor :north, :west, :east, :south, :visited, :distance

  def travel(direction)
    if public_send(direction)
      public_send(direction)
    else
      new = Room.new
      self.send("#{direction}=".to_sym, new)
      new.send("#{OPPOSITE[direction]}=".to_sym, self)
      $rooms << new
      new
    end
  end
end

home = Room.new
$rooms = [home]
current = home
stack = []

directions = ARGF.read.strip.split('')
directions.each do |dir|
  case dir
  when '('
    stack.push current
  when '|'
    current = stack.last
  when ')'
    stack.pop
  when 'N', 'E', 'W', 'S'
    current = current.travel(LOOKUP[dir])
  end
end

$rooms.each do |room|
  room.visited = false
  room.distance = Float::INFINITY
end

home.distance = 0
unvisited = $rooms.dup

while unvisited.any?
  min_distance = unvisited.map(&:distance).min
  current = unvisited.detect { |node| node.distance == min_distance }

  LOOKUP.values.each do |dir|
    if node = current.public_send(dir)
      node.distance = [node.distance, current.distance + 1].min
    end
    current.visited = true
    unvisited.delete(current)
  end
end

puts "Part 1: #{$rooms.map(&:distance).max}"
puts "Part 2: #{$rooms.select { |room| room.distance >= 1000 }.count}"
