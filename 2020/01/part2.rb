#!/usr/bin/env ruby

values = ARGF.read.lines.map(&:to_i)
puts values.combination(3).find { |a| a.inject(:+) == 2020 }.inject(:*)
