#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(input)
  input.lines.map do |line|
    numbers = line.strip.split(':')[1].split(' | ').map { _1.split.map(&:to_i) }
  end
end

def part1(data)
  data.sum { (2 ** ((_1 & _2).count - 1)).floor }
end

def part2(data)
  counts = Array.new(data.length, 1)
  data.each_with_index do |(a, b), idx|
    (a & b).count.times do |n|
      counts[idx + n + 1] += counts[idx]
    end
  end
  counts.first(data.length).sum
end

if File.exist?('input')
  data = parse(File.read('input'))
  puts "Part 1: #{part1(data)}"
  puts "Part 2: #{part2(data)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    parse(File.read('sample'))
  end

  def test_part1
    assert_equal(13, part1(sample))
  end

  def test_part2
    assert_equal(30, part2(sample))
  end
end
