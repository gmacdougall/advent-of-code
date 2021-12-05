#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.each_line.map { |line| line.match(/(\d+),(\d+) -> (\d+),(\d+)/).to_a.last(4).map(&:to_i) }
map = Hash.new(0)

orthoganal_lines = input.select { |l| l[0] == l[2] || l[1] == l[3] }
orthoganal_lines.each do |x1, y1, x2, y2|
  Range.new(*[x1, x2].sort).each do |x|
    Range.new(*[y1, y2].sort).each do |y|
      map[[x, y]] += 1
    end
  end
end

diagonal_lines = input.select { |l| [l[1] - l[3], l[3] - l[1]].include?(l[0] - l[2]) }
diagonal_lines.each do |x1, y1, x2, y2|
  x = x1
  y = y1
  map[[x, y]] += 1

  while x != x2
    x += x2 > x ? 1 : -1
    y += y2 > y ? 1 : -1

    map[[x, y]] += 1
  end
end

puts(map.values.count { |n| (n || 0) > 1 })
