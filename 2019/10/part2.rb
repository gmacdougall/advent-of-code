#!/usr/bin/env ruby

require_relative 'point'

MAP = File.read(ARGV.fetch(0)).strip.split("\n").map do |line|
  line.chars
end.freeze

WIDTH = MAP.first.length
HEIGHT = MAP.length

$points = []
hash = {}

WIDTH.times.each do |x|
  HEIGHT.times.each do |y|
    p = Point.new($points, x, y, MAP[y][x] == '#')
    $points << p
    hash[[x,y]] = p
  end
end

result = $points.select(&:asteroid).map do |origin|
  [origin, $points.count { |target| target != origin && !origin.blocked?(target) && target.asteroid }]
end

station = result.max_by(&:last).first

destroyed = []

down, up = $points.select { |p| p != station && p.x == station.x }.partition { |p| p.y > station.y }
all_right = $points.select { |p| p.x > station.x }
all_left = $points.select { |p| p.x < station.x }

while $points.count(&:asteroid) > 1
  puts "Starting Rotation"
  to_destroy = up.select(&:asteroid).min_by { |p| p.distance(station) }
  if to_destroy
    destroyed << to_destroy.vaporize
  end

  all_right.map { |p| p.ratio(station) }.sort.reverse.uniq.map do |ratio|
    all_right.select do |p|
      p.asteroid && p.ratio(station) == ratio
    end.min_by { |p| p.distance(station) }
  end.compact.each do |p|
    destroyed << p.vaporize
  end

  to_destroy = down.select(&:asteroid).min_by { |p| p.distance(station) }
  if to_destroy
    destroyed << to_destroy
    to_destroy.vaporize
  end

  all_left.map { |p| p.ratio(station) }.sort.reverse.uniq.map do |ratio|
    all_left.select do |p|
      p.asteroid && p.ratio(station) == ratio
    end.min_by { |p| p.distance(station) }
  end.compact.each do |p|
    destroyed << p.vaporize
  end
end

puts destroyed[199].x * 100 + destroyed[199].y
