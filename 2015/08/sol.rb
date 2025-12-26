#! /usr/bin/env ruby
# frozen_string_literal: true

def part1(fname)
  File.read(fname).lines(chomp: true).sum do |line|
    # WARNING: Unsafe eval
    line.length - eval(line).length
  end
end

def part2(fname)
  File.read(fname).lines(chomp: true).sum do |line|
    line.inspect.length - line.length
  end
end

if File.exist?('input')
  puts "Part 1: #{part1('input')}"
  puts "Part 2: #{part2('input')}"
end
