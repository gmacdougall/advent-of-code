#!/usr/bin/env ruby

def go(lines, offset)
  x = -offset
  lines.count do |line|
    x += offset
    line[x % line.strip.length] == '#'
  end
end

lines = ARGF.read.lines
puts go(lines, 1) *
  go(lines, 3) *
  go(lines, 5) *
  go(lines, 7) *
  go(lines.each_slice(2).map(&:first), 1)
