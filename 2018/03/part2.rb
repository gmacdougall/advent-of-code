#!/usr/bin/env ruby
require 'pry'

map = []
claims = []

ARGF.each do |line|
  claim, _, x_loc, y_loc, x_len, y_len = line.gsub(/[#,:x]/, ' ').split(' ').map(&:to_i)

  claims.push(claim)

  x_len.times do |x|
    y_len.times do |y|
      map[x_loc + x] ||= []
      map[x_loc + x][y_loc + y] ||= []

      map[x_loc + x][y_loc + y].push(claim)
    end
  end
end

puts claims - map.flatten(1).compact.select { |n| n && n.count > 1 }.flatten
