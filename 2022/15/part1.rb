#! /usr/bin/env ruby

input = ARGF.each_line.map(&:strip).map { _1.scan(/\-?\d+/).map(&:to_i) }

y_to_check = 2000000

ranges = []

beacons = []

input.each do |sx, sy, bx, by|
  beacons << [bx, by]
  distance_to_beacon = (sx - bx).abs + (sy - by).abs

  puts distance_to_beacon
  distance_to_check = (y_to_check - sy).abs
  next if distance_to_check > distance_to_beacon

  radius = (distance_to_check - distance_to_beacon).abs
  ranges << ((sx - radius)..(sx + radius))
end

beacons_on_line = beacons.select { _2 == y_to_check }.map(&:first)

p ranges

p (ranges.map(&:to_a).flatten.uniq - beacons_on_line.uniq).length
