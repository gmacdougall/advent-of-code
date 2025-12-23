#! /usr/bin/env ruby
# frozen_string_literal: true

def gen(a)
  b = a.reverse.chars.map { it == '1' ? '0' : '1' }
  "#{a}0#{b.join}"
end

def checksum(str)
  result = str
  while result.length.even?
    result = result.chars.each_slice(2).map do |a, b|
      a == b ? '1' : '0'
    end.join
  end
  result
end

def fill(len, init)
  data = init
  while data.length < len
    data = gen(data)
  end
  checksum(data[0...len])
end

def part1
  fill(272, '11110010111001001')
end

def part2
  fill(35_651_584, '11110010111001001')
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_gen
    assert_equal('100', gen('1'))
    assert_equal('001', gen('0'))
    assert_equal('11111000000', gen('11111'))
    assert_equal('1111000010100101011110000', gen('111100001010'))
  end

  def test_checksum
    assert_equal('100', checksum('110010110100'))
  end

  def test_fill
    assert_equal('01100', fill(20, '10000'))
  end
end
