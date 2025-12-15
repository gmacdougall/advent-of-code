#! /usr/bin/env ruby
# frozen_string_literal: true

def gen(start_value, multiple, mod)
  Enumerator.new do |f|
    n = start_value
    loop do
      n = (n * multiple) % 2147483647
      f.yield n if (n % mod) == 0
    end
  end
end

def go(start_a, start_b, a_mod, b_mod, size)
  gen_a = gen(start_a, 16807, a_mod)
  gen_b = gen(start_b, 48271, b_mod)

  count = 0

  size.times do |n|
    a = gen_a.next
    b = gen_b.next
    count += 1 if a % 65536 == b % 65536
  end
  count
end

puts "Part 1: #{go(679, 771, 1, 1, 40_000_000)}"
puts "Part 2: #{go(679, 771, 4, 8, 5_000_000)}"

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(588, go(65, 8921, 1, 1, 40_000_000))
  end

  def test_part2
    assert_equal(309, go(65, 8921, 4, 8, 5_000_000))
  end
end
