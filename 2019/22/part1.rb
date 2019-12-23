#!/usr/bin/env ruby

commands = File.read(ARGV.fetch(0)).strip.split("\n")

SIZE = 10_007
deck = (0...SIZE).to_a
commands.each do |command|
  if command.start_with?('deal into')
    deck = deck.reverse
  elsif command.start_with?('cut')
    n = command.split(' ').last.to_i
    if n > 0
      cut = deck.shift(n)
      deck.push(*cut)
    else
      cut = deck.pop(n.abs)
      deck.unshift(*cut)
    end
  else
    increment = command.split(' ').last.to_i
    table = []
    SIZE.times do |idx|
      pos = (increment * idx) % SIZE
      table[pos] = deck.shift
      pos += increment
    end
    deck = table
  end
end

puts deck[2020]
