#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  input = File.read(fname).split("\n\n")
  input.last.lines(chomp: true).map do |line|
    area, foo = line.split(': ')
    [area.split('x').map(&:to_i), foo.split(' ').map(&:to_i)]
  end
end

def part1(areas)
  areas.count do |(x, y), requirements|
    requirements.sum * 7 < x * y
  end
end

puts "Part 1: #{part1(parse('input'))}"
