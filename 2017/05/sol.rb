#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { _1.strip.to_i }
end

def part1(input)
  steps = 0
  idx = 0
  while idx < input.length
    val = input[idx]
    input[idx] += 1
    idx += val
    steps += 1
  end
  steps
end

def part2(input)
  steps = 0
  idx = 0
  while idx < input.length
    val = input[idx]
    if val >= 3
      input[idx] -= 1
    else
      input[idx] += 1
    end
    idx += val
    steps += 1
  end
  steps
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

  def test_part2
    assert_equal(10, part2(parse('sample')))
  end
end
