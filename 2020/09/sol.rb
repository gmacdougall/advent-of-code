#!/usr/bin/env ruby

PREAMBLE = 25

input = ARGF.lines.map(&:strip).map(&:to_i)

part1 = input.each_cons(PREAMBLE + 1).find do |*a, target|
  !a.combination(2).map(&:sum).include?(target)
end.last

p "Part 1: #{part1}"

(2..input.length).find do |n|
  result = input.each_cons(n).find { |arr| arr.sum == part1 }
  p "Part 2: #{result.minmax.sum}" if result
end
