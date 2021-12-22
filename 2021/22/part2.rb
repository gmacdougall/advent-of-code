#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

INPUT = ARGF.map do |line|
  [
    line.split.first,
    line.scan(/-?\d+/).map(&:to_i).each_slice(2).map(&:sort).map { |a, b| a..(b + 1) }
  ]
end.freeze

def overlap?(range_set1, range_set2)
  (0..2).any? { range_overlap? range_set1[_1], range_set2[_1] }
end

def range_overlap?(r1, r2)
  !((r1.end - 1) < r2.begin || (r2.end - 1) < r1.begin)
end

def set_cover?(big, small)
  big.zip(small).all? { |b, s| b.cover? s }
end

def area(ranges)
  ranges.map(&:minmax).map { |a, b| b - a }.inject(:*)
end

cubes = Set.new
INPUT.each do |i|
  puts cubes.length
  intersections = cubes.select { overlap?(_1, i.last) }

  if intersections.any?
    intersections.each do |inter|
      cubes.delete(inter)

      split = inter.each_with_index.map do |range, idx|
        (range.minmax + i.last[idx].minmax)
          .sort
          .each_cons(2).to_a.map { |a, b| Range.new(a, b) }
      end.inject(&:product).map(&:flatten)

      split.each do |s|
        if i.first == 'on'
          cubes.add(s) if set_cover?(inter, s) || set_cover?(i.last, s)
        elsif set_cover?(inter, s) && !set_cover?(i.last, s)
          cubes.add(s)
        end
      end
    end
  elsif i.first == 'on'
    cubes.add(i.last)
  end
end

puts cubes.sum { area _1 }
