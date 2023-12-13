#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

def reflection(data, mul)
  results = []
  data.each_with_index.each_cons(2).filter_map { |(a, ai), (b, bi)| [ai, bi] if a == b }.each do |a, b|
    diff = 0
    loop do
      break if data[a - diff] != data[b + diff]
      diff += 1
      results << b * mul if a - diff < 0 || !data[b + diff]
    end
  end
  results
end

class Map
  attr_reader :chars

  def initialize(chars)
    @chars = chars
  end

  def part1
    @part1 ||= reflection(chars, 100).first || reflection(chars.transpose, 1).first
  end

  def part2
    scores = []
    chars.each_with_index do |line, y|
      line.each_with_index do |chr, x|
        chars[y][x] = chr == '#' ? '.' : '#'
        scores.push(reflection(chars, 100), reflection(chars.transpose, 1))
        chars[y][x] = chr == '#' ? '#' : '.'
      end
    end
    scores.flatten.reject { _1 == part1 }.first
  end
end

def parse(file)
  file.split("\n\n").map do |chunk|
    Map.new(chunk.lines.map { _1.strip.chars })
  end
end

if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{input.sum(&:part1)}"
  puts "Part 2: #{input.sum(&:part2)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal([5, 400], parse(File.read('sample')).map(&:part1))
  end

  def test_part2
    assert_equal([300, 100], parse(File.read('sample')).map(&:part2))
  end
end
