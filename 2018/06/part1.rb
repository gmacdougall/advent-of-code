#!/usr/bin/env ruby

homes = []

x_max = 0
y_max = 0

ARGF.each_with_index do |line, idx|
  x, y = line.split(',').map(&:strip).map(&:to_i)
  homes << [x, y]
  x_max = [x, x_max].max
  y_max = [y, y_max].max
end

grid = []

(0..x_max).each do |x|
  (0..y_max).each do |y|
    distances = Hash[homes.each_with_index.map do |home, idx|
      [idx, (x - home[0]).abs + (y - home[1]).abs]
    end]
    grid[y] ||= []
    closest_distance = distances.values.min
    closest = distances.select { |_, v| v == closest_distance }
    grid[y][x]= closest.length > 1 ? '.' : closest.keys.first
  end
end

closest = homes.length.times.map do |idx|
  grid.flatten.count { |v| v == idx }
end

grid[0].each { |val| closest[val] = 0 unless val == '.' }
grid[grid.length - 1].each { |val| closest[val] = 0 unless val == '.' }
grid.each do |row|
  closest[row.first] = 0 unless row.first =='.'
  closest[row.last] = 0 unless row.last =='.'
end

puts closest.max

