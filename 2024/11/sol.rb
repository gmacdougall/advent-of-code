#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).split.map(&:to_i)
end

$cache = {}

def solve(steps, num)
  return 1 if steps.zero?
  return solve(steps - 1, 1) if num.zero?

  key = steps + num * 1000
  return $cache[key] if $cache.key?(key)

  len = (Math.log10(num) + 1).floor

  result =
    if len.even?
      split = 10**(len / 2)
      solve(steps - 1, num / split) + solve(steps - 1, num % split)
    else
      solve(steps - 1, num * 2024)
    end
  $cache[key] = result
  result
end

if File.exist?('input')
  puts "Part 1: #{parse('input').sum { solve 25, _1 }}"
  puts "Part 2: #{parse('input').sum { solve 75, _1 }}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_solve
    assert_equal(55_312, parse('sample').sum { solve 25, _1 })
  end
end
