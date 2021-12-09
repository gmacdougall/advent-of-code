#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.each_line.map { |line| line.strip.chars.map(&:to_i) }
low_points = []
input.each_with_index do |row, y|
  row.each_with_index do |val, x|
    adjacent = [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].reject { |pair| pair.any?(&:negative?) }
    low_points << val if adjacent.all? { |ax, ay| input.dig(ay, ax).nil? || input[ay][ax] > val }
  end
end
puts(low_points.map { _1 + 1 }.sum)
