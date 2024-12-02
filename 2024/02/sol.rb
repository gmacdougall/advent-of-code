#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { _1.split.map(&:to_i) }
end

def safe?(numbers)
  (numbers == numbers.sort || numbers == numbers.sort.reverse) &&
    numbers.each_cons(2).all? do |a, b|
      (a - b).abs.between?(1, 3)
    end
end

def part1(input) = input.count { safe?(_1) }

def part2(input)
  input.count do |numbers|
    numbers.combination(numbers.length - 1).any? { safe?(_1) }
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(2, part1(parse('sample')))
  end

  def test_part2
    assert_equal(4, part2(parse('sample')))
  end
end
