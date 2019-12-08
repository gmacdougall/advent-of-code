#!/usr/bin/env ruby

WIDTH = 25
HEIGHT = 6
SIZE = WIDTH * HEIGHT

layers = File.read('input').chars.map(&:to_i).each_slice(SIZE)

output = Array.new(SIZE, 2)

layers.each do |l|
  l.each_with_index do |n, idx|
    output[idx] = n if output[idx] == 2
  end
end

output.each_slice(WIDTH) do |line|
  puts line.join.gsub('0', ' ').gsub('1', '#')
end
