#! /usr/bin/env ruby

def ranges_overlap?(range_a, range_b)
  range_b.begin <= range_a.end && range_a.begin <= range_b.end 
end

input = ARGF.each_line.map(&:strip).map { _1.scan(/\-?\d+/).map(&:to_i) }

ranges = []
beacons = []

MAX = 4_000_000

(0..MAX).each do |y_to_check|
  puts y_to_check if (y_to_check % 10_000) == 0
  ranges = []
  input.each do |sx, sy, bx, by|
    beacons << [bx, by]
    distance_to_beacon = (sx - bx).abs + (sy - by).abs

    distance_to_check = (y_to_check - sy).abs
    next if distance_to_check > distance_to_beacon

    radius = (distance_to_check - distance_to_beacon).abs
    ranges << ((sx - radius)..(sx + radius))
  end
  ranges.sort_by!(&:first)
  min = 0
  ranges.each do |r|
    next if r.last < min
    if r.first > min
      puts ((min + 1) * MAX) + y_to_check
      exit
    end
    min = r.last
  end
end
