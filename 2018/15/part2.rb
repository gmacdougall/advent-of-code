#!/usr/bin/env ruby

require_relative './lib/map'

input = ARGF.read

elf_count = input.split('').select { |chr| chr == 'E' }.count

elf_power = 15
map = nil

while
  elf_power += 1
  map = Map.parse(input, elf_power)
  alive_elves = elf_count

  while !map.victory? && alive_elves == elf_count
    map.take_actions
    puts map.to_s
    alive_elves = map.characters.select { |c| c.type == 'E' }.count
  end

  break if alive_elves == elf_count
end

puts "Round: #{map.round}"
puts "HP: #{map.total_hp}"
puts "Score: #{map.score}"
