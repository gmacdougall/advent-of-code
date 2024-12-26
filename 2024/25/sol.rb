#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).split("\n\n").map do |line|
    line.gsub("\n", '').gsub('#', '1').gsub('.', '0').to_i(2)
  end
end

def part1(values)
  values.combination(2).count { (_1 & _2).zero? }
end

puts "Part 1: #{part1(parse('input'))}" if File.exist?('input')

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(3, part1(parse('sample')))
  end
end
