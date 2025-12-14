#! /usr/bin/env ruby
# frozen_string_literal: true

OPPOSITES = [
  %w[n s],
  %w[ne sw],
  %w[nw se],
]

SIMPLIFIED = {
  %w[ne s] => 'se',
  %w[se n] => 'ne',
  %w[nw s] => 'sw',
  %w[sw n] => 'nw',
  %w[se sw] => 's',
  %w[ne nw] => 'n',
}

def distance(steps)
  tallied = Hash.new(0).merge(steps.tally)
  OPPOSITES.each do |a, b|
    min = [tallied[a], tallied[b]].min
    tallied[a] -= min
    tallied[b] -= min
  end

  SIMPLIFIED.each do |(a, b), c|
    min = [tallied[a], tallied[b]].min
    tallied[a] -= min
    tallied[b] -= min
    tallied[c] += min
  end

  tallied.values.sum
end

def part1(input)
  distance(input.split(','))
end

def part2(input)
  steps = input.split(',')
  (1..steps.length).map do |n|
    distance(steps.first(n))
  end.max
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip)}"
  puts "Part 2: #{part2(File.read('input').strip)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(3, part1('ne,ne,ne'))
    assert_equal(0, part1('ne,ne,sw,sw'))
    assert_equal(2, part1('ne,ne,s,s'))
    assert_equal(3, part1('se,sw,se,sw,sw'))
  end
end
