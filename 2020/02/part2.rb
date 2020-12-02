#!/usr/bin/env ruby

puts(
  ARGF.read.lines.count do |line|
    range, char, pass = line.split(' ')
    p1, p2 = range.split('-').map(&:to_i)
    char.gsub!(':', '')
    (pass[p1 - 1] == char) ^ (pass[p2 - 1] == char)
  end
)
