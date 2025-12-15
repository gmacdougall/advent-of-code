#! /usr/bin/env ruby
# frozen_string_literal: true

def dance(arr, instructions, program_count)
  instructions.each do |inst|
    chars = inst.chars
    case chars.shift
    when 's'
      len = chars.join.to_i
      arr = arr[-len..] + arr[0...(program_count - len)]
    when 'x'
      a, b = chars.join.split('/').map(&:to_i)
      arr[a], arr[b] = arr[b], arr[a]
    when 'p'
      a, b = chars.join.split('/').map { arr.index(it) }
      arr[a], arr[b] = arr[b], arr[a]
    else
      fail
    end
  end
  arr
end

def part1(instructions, program_count)
  arr = Array.new(program_count) { |n| ('a'.ord + n).chr }
  arr = dance(arr, instructions, program_count)
  arr.join
end

def part2(instructions, program_count)
  arr = Array.new(program_count) { |n| ('a'.ord + n).chr }
  seen = {}
  (1..).each do |n|
    arr = dance(arr, instructions, program_count)
    if seen[arr]
      loop_size = n - seen[arr]
      result = seen.invert[(1_000_000_000 - seen[arr]) % loop_size + seen[arr]]
      return result.join
    else
      seen[arr.dup] = n
    end
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip.split(','), 16)}"
  puts "Part 2: #{part2(File.read('input').strip.split(','), 16)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal('baedc', part1(%w[s1 x3/4 pe/b], 5))
  end
end
