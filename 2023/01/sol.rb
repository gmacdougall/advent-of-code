#! /usr/bin/env ruby
# frozen_string_literal: true

NUM_MAP = %w[one two three four five six seven eight nine].freeze

def part1(input)
  input.each_line.sum { _1.gsub(/\D/, '').chars.values_at(0, -1).join.to_i }
end

def part2(input)
  NUM_MAP.each_with_index { |str, idx| input.gsub!(str, str[0..1] + (idx + 1).to_s + str[2..]) }
  part1(input)
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input'))}"
  puts "Part 2: #{part2(File.read('input'))}"
end

require 'test/unit'

class MyTest < Test::Unit::TestCase
  def test_part1
    assert_equal(142, part1(File.read('sample')))
  end

  def test_part2
    assert_equal(281, part2(File.read('sample2')))
  end
end
