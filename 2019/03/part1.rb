#!/usr/bin/env ruby

input = ARGF.read.strip.split("\n").map do |row|
  row.split(',').map { |i| [i[0], i[1..-1].to_i] }
end

results = input.map do |row|
  position = [0, 0]
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
      position.dup
    end
  end
end
puts (results[0] & results[1]).map { |pair| pair[0].abs + pair[1].abs }.min
