#! /usr/bin/env ruby

require_relative './node'
require 'set'

ARGF.map(&:strip).each_with_index do |row, y|
  row.chars.each_with_index do |val, x|
    Node.new(x, y, val)
  end
end

possible_starts = Node.nodes.values.select { _1.value == 'a'.ord }
finish = Node.finish

result = possible_starts.map do |start|
  to_eval = Set.new
  Node.reset
  current = start
  start.distance = 0
  until finish.visited || !current
    current.adjacent.each do |node|
      next if node.visited

      node.distance = [node.distance, current.distance + 1].compact.min
      to_eval << node
    end
    current.visited = true
    current = to_eval.min_by(&:distance)
    to_eval.delete current
  end
  finish.distance
end

p result.compact.min
