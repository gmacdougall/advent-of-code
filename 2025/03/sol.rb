#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { it.strip.chars.map(&:to_i) }
end

def solve(input, count)
  input.sum do |bank|
    count.downto(1).sum do |left|
      digit = bank[..-left].max
      pos = bank.index(digit)
      bank = bank[(pos + 1)..]
      digit * 10**(left - 1)
    end
  end
end

def part1(input) = solve input, 2
def part2(input) = solve input, 12

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(357, part1(parse('sample')))
  end

  def test_part2
    assert_equal(3_121_910_778_619, part2(parse('sample')))
  end
end
