#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname) = File.read(fname)

def part1(input)
  input.scan(/mul\((\d+),(\d+)\)/).sum { _1.to_i * _2.to_i }
end

def part2(input)
  enabled = true
  sum = 0
  input.scan(/(do\(\))|(don't\(\))|mul\((\d+),(\d+)\)/).map(&:compact).each do |x, y|
    if x == 'do()'
      enabled = true
    elsif x == "don't()"
      enabled = false
    elsif enabled
      sum += x.to_i * y.to_i
    end
  end
  sum
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(161, part1(parse('sample')))
  end

  def test_part2
    assert_equal(48, part2(parse('sample2')))
  end
end
