#! /usr/bin/env ruby

cycle = 0
x = 1
pixels = []

input = ARGF.map(&:strip).map(&:split).each do |command, val|
  count = command == 'addx' ? 2 : 1

  count.times do
    pixels << ((((cycle % 40) - 1)..(cycle % 40 + 1)).cover?(x) ? '#' : ' ')
    cycle += 1
  end

  x += val.to_i if command == 'addx'
end

puts pixels.each_slice(40).map(&:join).join("\n")
