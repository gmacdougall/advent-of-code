#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  input = File.read(fname).strip
  map = []
  input.chars.map(&:to_i).each_slice(2).each_with_index do |(n, gap), i|
    n.times { map.push i }
    gap&.times { map.push nil }
  end
  map
end

def checksum(map) = map.each_with_index.sum { _1 ? _1 * _2 : 0 }

def part1(map)
  front = 0
  back = map.length - 1

  loop do
    front += 1 while map[front]
    back -= 1 until map[back]

    break map if front > back

    map[front] = map[back]
    map[back] = nil
  end
  checksum(map)
end

def part2(map)
  chunked = map.chunk(&:object_id).map(&:last)
  chunked.reverse.each do |chunk|
    next unless chunk.first

    current = chunked.find_index { _1[0] == chunk[0] }
    potential = chunked.find_index { !_1[0] && _1.size >= chunk.size }

    next if !potential || potential > current

    chunked[current] = Array.new(chunk.size) { nil }
    chunked[potential] = Array.new(chunked[potential].size - chunk.size) { nil }
    chunked.insert(potential, chunk)
  end
  checksum(chunked.flatten)
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(1928, part1(parse('sample')))
  end

  def test_part2
    assert_equal(2858, part2(parse('sample')))
  end
end
