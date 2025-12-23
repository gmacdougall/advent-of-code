#! /usr/bin/env ruby
# frozen_string_literal: true

class Range
  def intersection(other)
    return nil if (self.max < other.begin or other.max < self.begin) 
    [self.begin, other.begin].max..[self.max, other.max].min
  end
  alias_method :&, :intersection
end

def parse(fname)
  File.read(fname).lines(chomp: true).map { Range.new(*it.split('-').map(&:to_i)) }
end

def part1(input)
  to_test = input.flat_map do |range|
    range.minmax.flat_map { [it - 1, it + 1] }
  end
  to_test = to_test.sort.select(&:positive?)
  to_test.find do |val|
    input.none? { it.cover?(val) }
  end
end

def part2(input)
  to_test = input.flat_map do |range|
    range.minmax.flat_map { [it - 1, it + 1] }
  end
  to_test = to_test.sort.select { it > 0 && it < 2**32 }
  boundaries = to_test.select do |val|
    input.none? { it.cover?(val) }
  end
  ranges = boundaries.each_slice(2).map { Range.new(_1, _2) }
  ranges.map(&:size).sum
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end
