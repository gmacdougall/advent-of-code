#! /usr/bin/env ruby

input = ARGF.map { _1.strip.chars }
scores = [0] + ('a'..'z').to_a + ('A'..'Z').to_a

[
  input.map { _1.each_slice(_1.size / 2) },
  input.each_slice(3),
].each do |x|
  p(
    x.map { _1.inject(:&) }.sum { scores.find_index(_1[0]) }
  )
end
