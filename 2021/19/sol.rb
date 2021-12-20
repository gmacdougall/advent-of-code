#! /usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

INPUT = ARGF.read.split("\n\n").map(&:each_line).map(&:to_a).freeze
scanners = INPUT.map do |lines|
  lines[1..].map { |line| Vector[*line.split(',').map(&:to_i)] }
end
SIN = Math.sin(Math::PI / 2)
COS = Math.cos(Math::PI / 2)

def rot_x(vec)
  x, y, z = vec.to_a
  Vector[
    x,
    ((COS * y) - (SIN * z)).round,
    ((COS * z) + (SIN * y)).round
  ]
end

def rot_y(vec)
  x, y, z = vec.to_a
  Vector[
    ((COS * x) + (SIN * z)).round,
    y,
    ((COS * z) - (SIN * x)).round
  ]
end

def rot_z(vec)
  x, y, z = vec.to_a
  Vector[
    ((COS * x) - (SIN * y)).round,
    ((SIN * x) + (COS * y)).round,
    z
  ]
end

def rotations(v)
  4.times.map do
    v = rot_x(v)
    4.times.map do
      v = rot_y(v)
      4.times.map do
        v = rot_z(v)
      end
    end
  end.flatten.uniq
end

# NOTE: This is actually distance squared to avoid a sqrt
def distance(v1, v2)
  v1.zip(v2).map { |a, b| (a - b)**2 }.sum
end

beacons = Set.new(scanners.shift)
scanner_positions = []

while (to_test = scanners.shift)
  distances1 = beacons.map { |b| [b, beacons.map { distance(b, _1) }] }.to_h
  distances2 = to_test.map { |b| [b, to_test.map { distance(b, _1) }] }.to_h

  something = distances1.map do |k1, d1|
    possible_match = distances2.find { |k2, d2| (d1 & d2).length >= 12 && k2 }
    possible_match && [k1, possible_match.first]
  end.compact

  rotated = Array.new(24) { |n| something.map { |k, v| [k, rotations(v)[n]] } }

  correct_rotation = rotated.find_index { |set| set.map { |a, b| a - b }.uniq.length == 1 }
  if correct_rotation
    diff = rotated[correct_rotation].first[0] - rotated[correct_rotation].first[1]
    scanner_positions << diff
    to_test.each { |vec| beacons << (rotations(vec)[correct_rotation] + diff) }
  else
    scanners.push to_test
  end
end

puts "Part 1: #{beacons.size}"
puts "Part 2: #{scanner_positions.combination(2).map { |a, b| a - b }.map { _1.to_a.map(&:abs).sum }.max}"
