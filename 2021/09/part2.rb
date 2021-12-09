#! /usr/bin/env ruby
# frozen_string_literal: true

INPUT = ARGF.each_line.map { |line| line.strip.chars.map(&:to_i) }.freeze

Y_BOUNDS = 0...INPUT.length
X_BOUNDS = 0...INPUT.first.length
ADJACENT_MOD = [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze

low_points = []
INPUT.each_with_index do |row, y|
  row.each_with_index do |val, x|
    low_points << [x, y] if ADJACENT_MOD.all? do |dx, dy|
      !X_BOUNDS.cover?(x + dx) || !Y_BOUNDS.cover?(y + dy) || INPUT[y + dy][x + dx] > val
    end
  end
end

def basin(visited, x, y)
  return 0 if visited[[x, y]] || !X_BOUNDS.cover?(x) || !Y_BOUNDS.cover?(y) || INPUT[y][x] == 9

  visited[[x, y]] = true

  1 + ADJACENT_MOD.sum { |dx, dy| basin(visited, x + dx, y + dy) }
end

puts(low_points.map { |x, y| basin({}, x, y) }.sort.last(3).inject(:*))
