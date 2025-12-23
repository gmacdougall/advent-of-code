#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map do |line|
    line.scan(/\d+/).map(&:to_i)
  end
end

def part1(input)
  lambdas = input.map do |disc|
    idx, num_pos, _, start = disc
    n = idx + start
    ->(t) { (n + t) % num_pos == 0 }
  end

  (0..).find do |t|
    lambdas.all? { it.call(t) }
  end
end

def part2(input)
  part1(input + [[7, 11, 0, 0]])
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(5, part1(parse('sample')))
  end
end
