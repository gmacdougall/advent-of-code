#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).split(',').map { Range.new(*it.split('-').map(&:to_i)) }
end

def part1(input)
  input.sum do |range|
    range.sum { it.to_s.match?(/^(\d+)\1$/) ? it : 0 }
  end
end

def part2(input)
  input.sum do |range|
    range.sum { it.to_s.match?(/^(\d+)\1+$/) ? it : 0 }
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(1_227_775_554, part1(parse('sample')))
  end

  def test_part2
    assert_equal(4_174_379_265, part2(parse('sample')))
  end
end
