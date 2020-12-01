#!/usr/bin/env ruby

values = ARGF.read.lines.map(&:to_i)
puts values.combination(2).find { |a, b| a + b == 2020 }.inject(:*)
