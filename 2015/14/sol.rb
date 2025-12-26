#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).map do |line|
    line.scan(/\d+/).map(&:to_i)
  end
end

def enum(speed, time, rest)
  Enumerator.new do |e|
    loop do
      time.times { e.yield speed }
      rest.times { e.yield 0 }
    end
  end
end

def part1(input, seconds)
  results = input.map { enum(*it).first(seconds).sum }
  results.max
end

def part2(input, seconds)
  enums = input.map { enum(*it) }
  points = Array.new(input.length) { 0 }
  current = Array.new(input.length) { 0 }
  seconds.times do
    enums.each_with_index do |e, idx|
      current[idx] += e.next
    end
    current.each_with_index.each { |a, b| points[b] += 1 if a == current.max }
  end
  points.max
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'), 2503)}"
  puts "Part 2: #{part2(parse('input'), 2503)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(1120, part1(parse('sample'), 1000))
  end
end
