#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.map { |l| l.scan(/(\d+)/).flatten.map(&:to_i) }
map = Hash.new(0)

def enumerate(start, finish)
  start.public_send(start < finish ? :upto : :downto, finish).to_a
end

input.each do |x1, y1, x2, y2|
  if x1 == x2 || y1 == y2
    enumerate(x1, x2).each do |x|
      enumerate(y1, y2).each do |y|
        map[[x, y]] += 1
      end
    end
  elsif (x1 - x2).abs == (y1 - y2).abs
    y_values = enumerate(y1, y2)
    enumerate(x1, x2).each_with_index do |x, idx|
      map[[x, y_values[idx]]] += 1
    end
  end
end

puts(map.values.count { |n| n && n > 1 })
