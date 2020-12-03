#!/usr/bin/env ruby

x = -3
puts(
  ARGF.read.lines.count do |line|
    x += 3
    line[x % line.strip.length] == '#'
  end
)
