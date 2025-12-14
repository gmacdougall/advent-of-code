#! /usr/bin/env ruby
# frozen_string_literal: true

def part1(input)
  arr = input.chars.map(&:to_i)
  arr << arr.first
  arr.each_cons(2).sum do |a, b|
    a == b ? a : 0
  end
end

def part2(input)
  arr = input.chars.map(&:to_i)
  len = arr.length
  arr.each_with_index.sum do |v, i|
    pair_idx = (i + (len / 2)) % len
    v == arr[pair_idx] ? v : 0
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip)}"
  puts "Part 2: #{part2(File.read('input').strip)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(3, part1('1122'))
    assert_equal(4, part1('1111'))
    assert_equal(0, part1('0'))
    assert_equal(9, part1('91212129'))
  end

  def test_part2
    assert_equal(6, part2('1212'))
    assert_equal(0, part2('1221'))
    assert_equal(4, part2('123425'))
    assert_equal(12, part2('123123'))
    assert_equal(4, part2('12131415'))
  end
end
