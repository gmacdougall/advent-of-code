#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { _1.strip.split(',').map { |s| Range.new(*s.split('-').map(&:to_i)) } }.first
end

def part1(input)
  count = 0
  input.each do |range|
    values = range.to_a
    values.each do |val|
      str = val.to_s
      len = str.length
      next if len.odd?

      mid = len / 2
      a = str[0...mid]
      b = str[mid..]

      count += val if a == b
    end
  end
  count
end

def part2(input)
  count = 0
  input.each do |range|
    values = range.to_a
    values.each do |val|
      str = val.to_s
      len = str.length
      chars = str.chars

      (1..(len / 2)).each do |split_len|
        next unless (str.length % split_len).zero?
        next if split_len >= len

        groups = chars.each_slice(split_len).to_a

        if groups.uniq.length == 1
          count += val
          break
        end
      end
    end
  end
  count
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(1_227_775_554, part1(parse('sample')))
  end

  def test_part2
    assert_equal(4_174_379_265, part2(parse('sample')))
  end
end
