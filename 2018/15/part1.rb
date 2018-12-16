#!/usr/bin/env ruby

require_relative './lib/map'

map = Map.parse(ARGF.read)

while !map.victory?
  map.take_actions
  puts map.to_s
end

puts "Round: #{map.round}"
puts "HP: #{map.total_hp}"
puts "Score: #{map.score}"
