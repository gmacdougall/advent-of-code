#! /usr/bin/env ruby
# frozen_string_literal: true

NUM_MAP = %w[_ one two three four five six seven eight nine].freeze

def part1(input)
  input.each_line.sum { _1.gsub(/\D/, '').chars.values_at(0, -1).join.to_i }
end

def part2(input)
  NUM_MAP.each_with_index { |str, idx| input.gsub!(str, "#{str}#{idx}#{str}") }
  part1(input)
end

if File.exist?('input')
  input = File.read('input')
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2(input)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(142, part1(File.read('sample')))
  end

  def test_part2
    assert_equal(281, part2(File.read('sample2')))
  end
end
