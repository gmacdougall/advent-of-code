#! /usr/bin/env ruby

totals = ARGF.read.split("\n\n").map { _1.split("\n").map(&:to_i) }.map(&:sum).sort
puts "Part 1: #{totals.last}"
puts "Part 2: #{totals.last(3).sum}"
