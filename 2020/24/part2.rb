#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

input = ARGF.lines.map(&:strip).map(&:chars)

tiles = Hash.new(false)

input.each do |line|
  x = 0
  y = 0

  while line.any?
    dir = line.shift
    dir += line.shift if dir == 'n' || dir == 's'

    case dir
    when 'ne'
      y += 1
      x += 0.5
    when 'nw'
      y += 1
      x -= 0.5
    when 'se'
      y -= 1
      x += 0.5
    when 'sw'
      y -= 1
      x -= 0.5
    when 'e'
      x += 1
    when 'w'
      x -= 1
    end
  end

  tiles[[x, y]] = !tiles[[x, y]]
end

def adjacent_indexes(x, y)
  [
    [x + 1, y],
    [x - 1, y],
    [x + 0.5, y + 1],
    [x + 0.5, y - 1],
    [x - 0.5, y + 1],
    [x - 0.5, y - 1],
  ]
end

100.times do |n|
  new_tiles = Hash.new(false)

  white_tiles_to_check = Set.new

  tiles.select { |k, v| v }.keys.each do |x, y|
    ai = adjacent_indexes(x, y)

    new_tiles[[x, y]] = (ai.count { |pos| tiles[pos] }).between?(1, 2)
    white_tiles_to_check.merge(ai.reject { |v| tiles[v] })
  end

  white_tiles_to_check.each do |x, y|
    new_tiles[[x, y]] = adjacent_indexes(x, y).count { |pos| tiles[pos] } == 2
  end

  tiles = new_tiles
  puts "Day #{n + 1}: #{tiles.values.count { |v| v }}"
end
