#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(file)
  file.lines.map { _1.scan(/\d+/).map(&:to_i) }
end

def part1(races)
  races.transpose.map do |time, distance|
    time.times.count { _1 * (time - _1) > distance }
  end
end

def part2(race)
  time, distance = race.map { _1.map(&:to_s).join.to_i }
  time.times.count { _1 * (time - _1) > distance }
end

if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{part1(input).inject(1, :*)}"
  puts "Part 2: #{part2(input)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    parse(File.read('sample'))
  end

  def test_part1
    assert_equal([4, 8, 9], part1(sample))
  end

  def test_part2
    assert_equal(71503, part2(sample))
  end
end
