#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative './node'

INPUT = ARGF.map { _1.chop.chars.map(&:to_i) }.freeze
X_SIZE = 0...INPUT.last.length
Y_SIZE = 0...INPUT.last.length

5.times do |x_grid|
  5.times do |y_grid|
    Y_SIZE.each do |y|
      X_SIZE.each do |x|
        Node.new(x + (x_grid * X_SIZE.end), y + (y_grid * Y_SIZE.end), INPUT[y][x] + x_grid + y_grid)
      end
    end
  end
end

start = Node.find(0, 0)
current = Node.find(
  Node.nodes.keys.map(&:first).max,
  Node.nodes.keys.map(&:last).max
)
current.distance = current.value

to_eval = Set.new

until start.visited
  current.adjacent.each do |node|
    next if node.visited

    node.distance = [node.distance, current.distance + node.value].compact.min
    to_eval << node
  end
  current.visited = true
  current = to_eval.min_by(&:distance)
  to_eval.delete current
end

puts start.distance - start.value
