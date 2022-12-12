#! /usr/bin/env ruby

require_relative './node'
require 'set'

ARGF.map(&:strip).each_with_index do |row, y|
  row.chars.each_with_index do |val, x|
    Node.new(x, y, val)
  end
end

start = Node.start
finish = Node.finish

start.distance = 0
to_eval = Set.new

current = start

until finish.visited
  current.adjacent.each do |node|
    next if node.visited

    node.distance = [node.distance, current.distance + 1].compact.min
    to_eval << node
  end
  current.visited = true
  current = to_eval.min_by(&:distance)
  to_eval.delete current
end

puts finish.distance
