#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(file)
  file.lines.map { _1.split.map(&:to_i) }
end

def values(set)
  values = [set]
  while !values.last.all?(&:zero?)
    values << values.last.each_cons(2).map { _2 - _1 }
  end
  values.reverse
end

def part1(input)
  input.sum { |set| values(set).inject(0) { _1 + _2.last } }
end

def part2(input)
  input.sum { |set| values(set).inject(0) { _2.first - _1 } }
end

if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2(input)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    parse(File.read('sample'))
  end

  def test_part1
    assert_equal(114, part1(sample))
  end

  def test_part2
    assert_equal(2, part2(sample))
  end
end
