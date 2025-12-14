#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { it.split(': ').map(&:to_i) }.to_h
end

def part1(input)
  times_at_zero = input.map { [_1, 2 * (_2 - 1)] }.to_h
  times_at_zero.sum do |k, v|
    (k % v).zero? ? k * input[k] : 0
  end
end

def part2(input)
  times_at_zero = input.map { [_1, 2 * (_2 - 1)] }.to_h
  (0..).each do |n|
    return n unless times_at_zero.any? do |k, v|
      ((k + n) % v).zero?
    end
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(24, part1(parse('sample')))
  end

  def test_part2
    assert_equal(10, part2(parse('sample')))
  end
end
