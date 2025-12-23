#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).map(&:chars)
end

def part1(input)
  input.transpose.map(&:tally).map { it.sort_by(&:last).last }.map(&:first).join
end

def part2(input)
  input.transpose.map(&:tally).map { it.sort_by(&:last).first }.map(&:first).join
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal('easter', part1(parse('sample')))
  end

  def test_part2
    assert_equal('advent', part2(parse('sample')))
  end
end
