#! /usr/bin/env ruby
# frozen_string_literal: true

def part1(str)
  tally = str.chars.tally
  tally.fetch('(', 0) - tally.fetch(')', 0)
end

def part2(str)
  floor = 0
  str.chars.find_index do |chr|
    floor += chr == '(' ? 1 : -1
    floor == -1
  end + 1
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip)}"
  puts "Part 2: #{part2(File.read('input').strip)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(0, part1('(())'))
    assert_equal(0, part1('()()'))
    assert_equal(3, part1('((('))
    assert_equal(3, part1('(()(()('))
    assert_equal(3, part1('))((((('))
    assert_equal(-1, part1('())'))
    assert_equal(-1, part1('))('))
    assert_equal(-3, part1(')))'))
    assert_equal(-3, part1(')())())'))
  end

  def test_part2
    assert_equal(1, part2(')'))
    assert_equal(5, part2('()())'))
  end
end
