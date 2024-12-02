#! /usr/bin/env ruby
# frozen_string_literal: true

def lists(fname)
  File.read(fname).lines.map { _1.split.map(&:to_i) }.transpose.map(&:sort)
end

def part1(a, b) = a.zip(b).sum { (_2 - _1).abs }
def part2(a, b) = a.sum { _1 * b.tally.fetch(_1, 0) }

if File.exist?('input')
  puts "Part 1: #{part1(*lists('input'))}"
  puts "Part 2: #{part2(*lists('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(11, part1(*lists('sample')))
  end

  def test_part2
    assert_equal(31, part2(*lists('sample')))
  end
end
