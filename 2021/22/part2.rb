#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

# Borrowed from StackOverflow
class Range
  def intersection(other)
    intersection_begin =
      case
      when include?(other.begin)
        other.begin
      when other.include?(self.begin)
        self.begin
      else
        return nil
      end

    intersection_end, intersection_exclude_end =
      case self.end <=> other.end
      when -1
        [self.end, exclude_end?]
      when 1
        [other.end, other.exclude_end?]
      when 0
        [self.end, exclude_end? || other.exclude_end?]
      end

    self.class.new(intersection_begin, intersection_end, intersection_exclude_end)
  end

  alias_method :&, :intersection # rubocop:disable Style/Alias
end

INPUT = ARGF.map do |line|
  [
    line.split.first,
    line.scan(/-?\d+/).map(&:to_i).each_slice(2).map(&:sort).map { |a, b| a..(b + 1) }
  ]
end.freeze

def overlap?(range_set1, range_set2)
  (0..2).none? { (range_set1 & range_set2).nil? }
end

def set_cover?(big, small)
  big & small == small
end

def intersect(a, b)
  [
    a[0] & b[0],
    a[1] & b[1],
    a[2] & b[2]
  ]
end

cubes = {}
INPUT.each do |i|
  cubes.dup.each do |c, count|
    int = intersect(i.last, c)
    next if int.any?(&:nil?)

    cubes[int] ||= 0
    cubes[int] -= count
  end
  cubes[i.last] ||= 0
  cubes[i.last] += 1 if i.first == 'on'
end

def area(ranges)
  ranges.map(&:minmax).map { |a, b| b - a }.inject(:*)
end
puts(cubes.sum { |r, count| area(r) * count })
