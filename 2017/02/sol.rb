#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { _1.scan(/\d+/).map(&:to_i) }
end

def part1(input)
  input.sum do |line|
    line.minmax.inject(:-).abs
  end
end

def part2(input)
  input.sum do |line|
    line.combination(2).sum do |vals|
      a, b = vals.sort
      b % a == 0 ? b / a : 0
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
    assert_equal(18, part1(parse('sample')))
  end

  def test_part2
    assert_equal(9, part2(parse('sample2')))
  end
end
