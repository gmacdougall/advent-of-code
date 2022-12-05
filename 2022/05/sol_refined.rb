#! /usr/bin/env ruby

start, instructions = ARGF.read.split("\n\n")

part1 = start.
  lines.
  reverse[1..].
  map(&:chars).
  transpose.
  map { |a| a.select { _1.match(/\w/) } }.
  reject(&:empty?)

instructions = instructions.
  lines.
  map { _1.split.map(&:to_i) }

part2 = part1.map(&:dup)

instructions.each do |_, to_move, _, from, _, to|
  to_move.times do
    part1[to - 1].push(part1[from - 1].pop)
  end
  part2[to - 1].push(*part2[from - 1].pop(to_move))
end

puts part1.map(&:last).join
puts part2.map(&:last).join
