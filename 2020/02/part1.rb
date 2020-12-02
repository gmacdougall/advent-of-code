#!/usr/bin/env ruby

puts(
  ARGF.read.lines.count do |line|
    range, char, pass = line.split(' ')
    Range.new(*range.split('-').map(&:to_i)).include?(pass.count(char[0]))
  end
)
