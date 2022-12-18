#! /usr/bin/env ruby
require 'set'

input = ARGF.map(&:strip).map { _1.scan(/-?\d+/).map(&:to_i) }
set = Set.new(input)

count = 0
values = {}

x_range = Range.new(*set.map { _1[0] }.minmax)
y_range = Range.new(*set.map { _1[1] }.minmax)
z_range = Range.new(*set.map { _1[2] }.minmax)

[x_range.min - 1, x_range.max + 1].each do |x|
  y_range.each do |y|
    z_range.each do |z|
      values[[x, y, z]] = :water
    end
  end
end

x_range.each do |x|
  [y_range.min - 1, y_range.max + 1].each do |y|
    z_range.each do |z|
      values[[x, y, z]] = :water
    end
  end
end

x_range.each do |x|
  y_range.each do |y|
    [z_range.min - 1, z_range.max + 1].each do |z|
      values[[x, y, z]] = :water
    end
  end
end

x_range.each do |x|
  y_range.each do |y|
    z_range.each do |z|
      values[[x, y, z]] = set.include?([x, y, z]) ? :cube : :air
    end
  end
end

hash = nil

while hash != values.hash
  hash = values.hash
  values.each do |(x, y, z), type|
    next unless type == :water

    possibilities = [
      [x + 1, y, z],
      [x - 1, y, z],
      [x, y + 1, z],
      [x, y - 1, z],
      [x, y, z + 1],
      [x, y, z - 1],
    ]

    possibilities.each do |p|
      values[p] = :water if values[p] && values[p] != :cube
    end
  end
end

set.each do |x, y, z|
  possibilities = [
    [x + 1, y, z],
    [x - 1, y, z],
    [x, y + 1, z],
    [x, y - 1, z],
    [x, y, z + 1],
    [x, y, z - 1],
  ]
  possibilities.each do |p|
    count += 1 if values[p] == :water
  end
end

p count
