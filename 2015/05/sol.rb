#! /usr/bin/env ruby
# frozen_string_literal: true

BANNED_STRS = %w[ab cd pq  xy]

def part1_nice?(str)
  str.chars.tally.values_at('a', 'e', 'i', 'o', 'u').compact.sum >= 3  &&
    str.match?(/(\w)\1/) &&
    BANNED_STRS.none? { str.include? it }
end

def part2_nice?(str)
  str.match?(/(\w\w).*\1/) && str.match?(/(\w)\w\1/)
end

def part1(fname)
  File.read(fname).lines(chomp: true).count { part1_nice? it }
end

def part2(fname)
  File.read(fname).lines(chomp: true).count { part2_nice? it }
end

if File.exist?('input')
  puts "Part 1: #{part1('input')}"
  puts "Part 2: #{part2('input')}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert(part1_nice?('ugknbfddgicrmopn'))
    assert(part1_nice?('aaa'))
    assert(!part1_nice?('jchzalrnumimnmhp'))
    assert(!part1_nice?('haegwjzuvuyypxyu'))
    assert(!part1_nice?('dvszwmarrgswjxmb'))
  end

  def test_part2
    assert(part2_nice?('qjhvhtzxzqqjkmpb'))
    assert(part2_nice?('xxyxx'))
    assert(!part2_nice?('uurcxstgmygtbstg'))
    assert(!part2_nice?('ieodomkazucvgmuy'))
  end
end
