#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.map { |l| l.scan(/(\d+)/).flatten.map(&:to_i) }
map = Hash.new(0)

def enumerate(start, finish)
  start.public_send(start < finish ? :upto : :downto, finish).to_a
end

input.each do |x1, y1, x2, y2|
  if x1 == x2
    enumerate(y1, y2).each { |y| map[[x1, y]] += 1 }
  elsif y1 == y2
    enumerate(x1, x2).each { |x| map[[x, y1]] += 1 }
  elsif (x1 - x2).abs == (y1 - y2).abs
    enumerate(x1, x2).zip(enumerate(y1, y2)).each do |x, y|
      map[[x, y]] += 1
    end
  end
end

puts(map.values.count { |n| n > 1 })
