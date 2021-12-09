#! /usr/bin/env ruby
# frozen_string_literal: true

INPUT = ARGF.each_line.map { |line| line.strip.chars.map(&:to_i) }.freeze

Y_BOUNDS = 0...INPUT.length
X_BOUNDS = 0...INPUT.first.length

low_points = []
INPUT.each_with_index do |row, y|
  row.each_with_index do |val, x|
    adjacent = [
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1]
    ].select { |ax, ay| X_BOUNDS.cover?(ax) && Y_BOUNDS.cover?(ay) }
    low_points << [x, y] if adjacent.all? { |ax, ay| INPUT[ay][ax] > val }
  end
end

def basin(visited, x, y)
  return 0 if visited[[x, y]] || !X_BOUNDS.cover?(x) || !Y_BOUNDS.cover?(y) || INPUT[y][x] == 9

  visited[[x, y]] = true

  1 +
    basin(visited, x + 1, y) +
    basin(visited, x - 1, y) +
    basin(visited, x, y + 1) +
    basin(visited, x, y - 1)
end

result = low_points.map do |x, y|
  basin({}, x, y)
end
puts result.sort.last(3).inject(:*)
