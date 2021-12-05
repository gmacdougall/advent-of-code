#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.each_line.map { |line| line.match(/(\d+),(\d+) -> (\d+),(\d+)/).to_a.last(4).map(&:to_i) }
input.select! { |line| line[0] == line[2] || line[1] == line[3] }

map = []
input.each do |x1, y1, x2, y2|
  Range.new(*[x1, x2].sort).each do |x|
    Range.new(*[y1, y2].sort).each do |y|
      map[y] ||= []
      map[y][x] ||= 0
      map[y][x] += 1
    end
  end
end
puts(map.flatten.count { |n| (n || 0) > 1 })
