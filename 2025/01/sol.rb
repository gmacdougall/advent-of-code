#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { _1.strip.chars }
end

def part1(fname)
  pos = 50

  parse(fname).count do |dir, *num|
    num = num.join.to_i
    num = -num if dir == 'L'

    pos += num
    pos %= 100
    pos.zero?
  end
end

def part2(fname)
  pos = 50
  parse(fname).sum do |dir, *num|
    num.join.to_i.times.count do
      pos += dir == 'L' ? -1 : 1
      pos %= 100
      pos.zero?
    end
  end
end

if File.exist?('input')
  puts "Part 1: #{part1('input')}"
  puts "Part 2: #{part2('input')}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(3, part1('sample'))
  end

  def test_part2
    assert_equal(6, part2('sample'))
  end
end
