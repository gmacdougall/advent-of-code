#! /usr/bin/env ruby

lines = ARGF.
  flat_map do |l|
    sx, sy, bx, by = l.scan(/\-?\d+/).map(&:to_i)
    d = (sx - bx).abs + (sy - by).abs
    [
      [1, sy + d - sx],
      [1, sy - d - sx],
      [-1, sy - d + sx],
      [-1, sy + d + sx],
    ]
  end.
  combination(2).
  select { |a, b| a[0] == b[0] && (a[1] - b[1]).abs == 2 }.
  map { |l| [l[0][0], l.sum { _1[1] } / 2] }

raise "This doesn't work for your input, sorry" if lines.length > 2

m1, b1, m2, b2 = lines.flatten

x = (b2 - b1)/(m1 - m2)
y = (m1*b2 - m2*b1)/(m1 - m2)

puts x * 4_000_000 + y
