#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  input = File.read(fname).split("\n\n")
  presents = input.shift(6).map { it.lines.last(3).map { |l| l.strip.gsub('#', '1').gsub('.', '0').chars.map(&:to_i) }}
  areas = input.first.lines(chomp: true).map do |line|
    area, foo = line.split(': ')
    [area.split('x').map(&:to_i), foo.split(' ').map(&:to_i)]
  end
  [presents, areas]
end

def part1(presents, areas)
  areas.count do |(x, y), requirements|
    requirements.each_with_index.sum { |req, idx| req * presents[idx].flatten.count { it == 1 } } < x * y
  end
end

puts "Part 1: #{part1(*parse('input'))}"
