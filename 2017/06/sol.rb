#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).scan(/\d+/).map(&:to_i)
end

def call(input)
  len = input.length
  seen = Hash.new(0)

  start_loop = nil

  (1..).each do |iter|
    idx = input.index(input.max)
    dist = input[idx]
    input[idx] = 0
    dist.times do |n|
      input[(idx + n + 1) % len] += 1
    end

    start_loop ||= iter if seen.key?(input)
    return [start_loop, iter] if seen[input] == 2
    seen[input] += 1
  end
end

if File.exist?('input')
  one, two = call(parse('input'))
  puts "Part 1: #{one}"
  puts "Part 2: #{two - one}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(5, call(parse('sample'))[0])
  end

  def test_part2
    assert_equal(4, call(parse('sample')).inject(:-).abs)
  end
end
