#! /usr/bin/env ruby

DEPTH = 5913
TARGET = [8, 701]

$index_cache = {}
$nodes = []

class Node
  attr_accessor :distance
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @distance = {
      torch: Float::INFINITY,
      gear: Float::INFINITY,
      neither: Float::INFINITY,
    }
  end

  def valid_tools
    case type
    when 0
      [:gear, :torch]
    when 1
      [:gear, :neither]
    when 2
      [:torch, :neither]
    end
  end

  def type
    geologic_index % 3
  end

  def up
    $nodes[y - 1][x] if y > 0
  end

  def down
    $nodes[y + 1][x] if $nodes[y + 1]
  end

  def left
    $nodes[y][x - 1] if x > 0
  end

  def right
    $nodes[y][x + 1]
  end

  def adjacent
    [up, down, left, right].compact
  end

  def geologic_index
    if $index_cache["#{x}-#{y}"].nil?
      result = if x == 0 && y == 0
        0
      elsif TARGET.first == x && TARGET.last == y
        0
      elsif y == 0
        x * 16807
      elsif x == 0
        y * 48271
      else
        up.geologic_index * left.geologic_index
      end
      $index_cache["#{x}-#{y}"] = (result + DEPTH) % 20183
    end
    $index_cache["#{x}-#{y}"]
  end
end

(0..(TARGET.last + 20)).each do |y|
  $nodes[y] = []
  (0..(TARGET.first + 20)).each do |x|
    $nodes[y][x] = Node.new(x, y)
  end
end

home = $nodes[0][0]
home.distance[:torch] = 0
target = $nodes[TARGET.last][TARGET.first]

unvisited = $nodes.flatten

while unvisited.any?
  min_distance = unvisited.flat_map { |node| node.distance.values }.min
  current = unvisited.detect { |node| node.distance.values.any? { |v| v == min_distance } }

  current.valid_tools.each do |tool|
    min_distance = current.distance.values.min
    if current.distance[tool] > min_distance + 7
      current.distance[tool] = min_distance + 7
    end
  end

  current.adjacent.each do |node|
    possible_tools = (node.valid_tools & current.valid_tools)
    possible_tools.each do |tool|
      if node.distance[tool] > current.distance[tool] + 1
        node.distance[tool] = current.distance[tool] + 1
        unvisited << node unless unvisited.include?(node)
      end
    end
  end

  unvisited.delete(current)
  puts unvisited.length
end

puts target.inspect
