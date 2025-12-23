#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { it.scan(/\d+/).map(&:to_i) }
end

def valid(a, b, c) = a + b > c

def part1(input)
  input.count { valid *it.sort }
end

def part2(input)
  input.transpose.flatten.each_slice(3).count { valid *it.sort }
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end
