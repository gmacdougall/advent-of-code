#! /usr/bin/env ruby

start, instructions = ARGF.read.split("\n\n")
start = start.split("\n").map { _1.chars }.reverse[1..]
instructions = instructions.split("\n").map { _1.split(' ').map(&:to_i) }

stacks = []

start.each do |line|
  i = (1..35).step(4).each_with_index do |v, idx|
    stacks[idx] ||= []
    stacks[idx].push(line[v]) unless line[v] == ' '
  end
end

part1 = stacks.map(&:dup)
part2 = stacks.map(&:dup)

instructions.each do |_, to_move, _, from, _, to|
  to_move.times do
    part1[to - 1].push(part1[from - 1].pop)
  end
  part2[to - 1].push(*part2[from - 1].pop(to_move))
end

puts part1.map(&:last).join
puts part2.map(&:last).join
