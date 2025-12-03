#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { it.strip.chars.map(&:to_i) }
end

def part1(input)
  input.sum do |bank|
    max = 0
    while bank.length > 1
      value = bank.shift * 10 + bank.max
      max = [max, value].max
    end
    max
  end
end

def part2(input)
  input.sum do |bank|
    value = 0
    left = 12

    while left.positive?
      digit = bank[0..-left].max
      left -= 1

      pos = bank.index(digit)
      value += digit * 10**left

      bank = bank[(pos + 1)..]
    end

    value
  end
end

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
