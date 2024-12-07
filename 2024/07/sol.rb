#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map do |line|
    left, right = line.split(':')
    [left.to_i, right.split.map(&:to_i)]
  end
end

def part1(input)
  input.select do |result, numbers|
    poss = [numbers.shift]
    numbers.each do |num|
      poss = poss.flat_map { [_1 + num, _1 * num] }
    end
    poss.include?(result)
  end.sum(&:first)
end

def part2(input)
  input.select do |result, numbers|
    poss = [numbers.shift]
    numbers.each do |num|
      poss = poss.flat_map { [_1 + num, _1 * num, (_1.to_s + num.to_s).to_i] }
    end
    poss.include?(result)
  end.sum(&:first)
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(3749, part1(parse('sample')))
  end

  def test_part2
    assert_equal(11_387, part2(parse('sample')))
  end
end
