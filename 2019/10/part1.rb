#!/usr/bin/env ruby

require_relative 'point'

MAP = File.read(ARGV.fetch(0)).strip.split("\n").map do |line|
  line.chars
end.freeze

WIDTH = MAP.first.length
HEIGHT = MAP.length

$points = []

WIDTH.times.each do |x|
  HEIGHT.times.each do |y|
    $points << Point.new($points, x, y) if MAP[y][x] == '#'
  end
end

result = $points.map do |origin|
  [origin, $points.count { |target| target != origin && !origin.blocked?(target) }]
end

puts result.max_by(&:last)
