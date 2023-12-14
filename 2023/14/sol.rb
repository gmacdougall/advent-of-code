#! /usr/bin/env ruby
# frozen_string_literal: true

class Array
  def swap(a, b)
    self[a], self[b] = self[b], self[a]
  end
end

require 'pry'
def parse(file)
  Map.new(file.lines.map { _1.strip.chars })
end

class Map
  attr_reader :arr
  def initialize(arr)
    @arr = arr.transpose
    rotations = 0
  end

  def roll
    arr.length.times do |y|
      empty_space = nil
      arr[y].length.times do |x|
        chr = arr[y][x]
        if chr == 'O' && empty_space
          arr[y].swap(x, empty_space)
          empty_space += 1
        elsif chr == '.' && !empty_space
          empty_space = x
        elsif chr == '#'
          empty_space = nil
        end
      end
    end
  end

  def score
    len = arr.first.count
    arr.sum do |row|
      row.each_with_index.sum do |chr, idx|
        chr == 'O' ? len - idx : 0
      end
    end
  end

  def part1
    roll
    score
  end

  def rotate
    @arr = arr.transpose.reverse
  end

  def part2
    results = {}
    1000000000.times do |n|
      4.times do
        roll
        rotate
      end

      if (results[@arr.hash])
        start = results[@arr.hash][:iter]
        loop_length = n - results[@arr.hash][:iter]
        offset = (1_000_000_000 - start) % loop_length
        return results.find { _2[:iter] == start + offset - 1 }[1][:score]
      end
      results[@arr.hash] = { iter: n, score: score }
    end
  end
end

if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{input.part1}"
  puts "Part 2: #{input.part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(136, parse(File.read('sample')).part1)
  end

  def test_part2
    assert_equal(64, parse(File.read('sample')).part2)
  end
end
