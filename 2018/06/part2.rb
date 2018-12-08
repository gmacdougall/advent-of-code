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

count = 0

(0..x_max).each do |x|
  (0..y_max).each do |y|
    distances = homes.each_with_index.map do |home, idx|
      (x - home[0]).abs + (y - home[1]).abs
    end
    count += 1 if distances.sum < 10_000
  end
end

puts count
