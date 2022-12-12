#! /usr/bin/env ruby

require_relative './node'
require 'set'

ARGF.map(&:strip).each_with_index do |row, y|
  row.chars.each_with_index do |val, x|
    Node.new(x, y, val)
  end
end

current = Node.start
current.distance = 0
finish = Node.finish
to_eval = Set.new

# Only difference for part 2
Node.nodes.values.select { _1.value == 'a'.ord }.each { _1.distance = 0 }

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
