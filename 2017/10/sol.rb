#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).split(',').map(&:to_i)
end

def go(input, times, size = 256)
  arr = Array.new(size) { _1 }
  pos = 0
  skip_size = 0

  times.times do
    input.each do |len|
      start = pos
      finish = (pos + len - 1) % size
      (len / 2).times do
        tmp = arr[start]
        arr[start] = arr[finish]
        arr[finish] = tmp

        start = (start + 1) % size
        finish = (finish - 1) % size
      end

      pos = (pos + len + skip_size) % size
      skip_size += 1
    end
  end
  arr
end

def part1(input, size = 256)
  go(parse(input), 1, size).first(2).inject(:*)
end

def knot_hash(input)
  instructions = input.strip.chars.map(&:ord) + [17, 31, 73, 47, 23]
  go(instructions, 64, 256).each_slice(16).map { it.inject(:^).to_s(16).rjust(2, '0') }.join
end

def part2(input) = knot_hash(input)

if File.exist?('input')
  puts "Part 1: #{part1('input')}"
  puts "Part 2: #{part2(File.read('input').strip)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(12, part1('sample', 5))
  end

  def test_part2
    return
    assert_equal('a2582a3a0e66e6e86e3812dcb672a272', part2(''))
    assert_equal('33efeb34ea91902bb2f59c9920caa6cd', part2('AoC 2017'))
    assert_equal('3efbe78a8d82f29979031a4aa0b16a9d', part2('1,2,3'))
    assert_equal('63960835bcdc130f0b66d7ff4f6a5a8e', part2('1,2,4'))
  end
end
