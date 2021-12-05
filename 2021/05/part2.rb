#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.each_line.map { |line| line.match(/(\d+),(\d+) -> (\d+),(\d+)/).to_a.last(4).map(&:to_i) }
map = Hash.new(0)

def enumerate(val1, val2)
  val1.public_send(val1 < val2 ? :upto : :downto, val2).to_a
end

orthoganal_lines = input.select { |l| l[0] == l[2] || l[1] == l[3] }
orthoganal_lines.each do |x1, y1, x2, y2|
  enumerate(x1, x2).each do |x|
    enumerate(y1, y2).each do |y|
      map[[x, y]] += 1
    end
  end
end

diagonal_lines = input.select { |l| (l[1] - l[3]).abs == (l[0] - l[2]).abs }
diagonal_lines.each do |x1, y1, x2, y2|
  y_values = enumerate(y1, y2)
  enumerate(x1, x2).each_with_index do |x, idx|
    map[[x, y_values[idx]]] += 1
  end
end

puts(map.values.count { |n| n && n > 1 })
