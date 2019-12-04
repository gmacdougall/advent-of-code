#!/usr/bin/env ruby

input = ARGF.read.strip.split("\n").map do |row|
  row.split(',').map { |i| [i[0], i[1..-1].to_i] }
end

wire1, wire2 = input.map do |row|
  position = [0, 0]
  steps = 0
  row.flat_map do |dir, distance|
    distance.times.map do
      case dir
      when 'U'
        position[0] += 1
      when 'D'
        position[0] -= 1
      when 'L'
        position[1] -= 1
      when 'R'
        position[1] += 1
      else
        fail
      end
      steps += 1
      [position.dup, steps]
    end
  end
end

result = (wire1.map(&:first) & wire2.map(&:first)).map do |point|
  wire1.find { |pair| pair[0] == point }.last + wire2.find { |pair| pair[0] == point }.last
end

puts result.min
