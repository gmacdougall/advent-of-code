#! /usr/bin/env ruby

totals = ARGF.read.split("\n\n").map { _1.split("\n").map(&:to_i).sum }
puts "Part 1: #{totals.max}"
puts "Part 2: #{totals.max(3).sum}"
