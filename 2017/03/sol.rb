#! /usr/bin/env ruby
# frozen_string_literal: true

def rotation
  fib = Enumerator.new do |f|
    n = 1
    loop do
      n.times { f.yield [1, 0] }
      n.times { f.yield [0, -1] }
      n += 1
      n.times { f.yield [-1, 0] }
      n.times { f.yield [0, 1] }
      n += 1
    end
  end
end

def part1(val)
  seq = rotation
  x = 0
  y = 0

  (val - 1).times do
    dx, dy = seq.next
    x += dx
    y += dy
  end

  x.abs + y.abs
end

def part2(input)
  hash = { [0, 0] => 1 }
  seq = rotation
  x = 0
  y = 0

  loop do
    dx, dy = seq.next
    x += dx
    y += dy

    val = (-1..1).sum do |xx|
      (-1..1).sum do |yy|
        hash.fetch([x + xx, y + yy], 0)
      end
    end

    return val if val > input

    hash[[x, y]] = val
  end
end

puts "Part 1: #{part1(312051)}"
puts "Part 2: #{part2(312051)}"

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(0, part1(1))
    assert_equal(3, part1(12))
    assert_equal(2, part1(23))
    assert_equal(31, part1(1024))
  end
end
