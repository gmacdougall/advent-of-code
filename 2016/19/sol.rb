#! /usr/bin/env ruby
# frozen_string_literal: true

class Elf
  def initialize(n)
    @n = n
  end

  attr_reader :n
  attr_accessor :left
end

def part1(size)
  elves = size.times.map { Elf.new(_1 + 1) }
  elves.each_cons(2) { _1.left = _2 }
  elves.last.left = elves.first

  elf = elves.first
  size.downto(2).each do |cur_size|
    left = elf.left
    elf.left = left.left
    elf = elf.left
  end

  elf.n
end

# Very slow: But it works
def part2(size)
  arr = Array.new(size) { it + 1};
  idx = 0
  (size - 1).times do |n|
    puts n if n % 1000 == 0
    to_delete = (idx + (arr.length / 2)) % arr.length
    arr.delete_at(to_delete)
    idx -= 1 if to_delete < idx
    idx = (idx + 1) % arr.length
  end
  arr.first
end

if File.exist?('input')
  puts "Part 1: #{part1(3_014_603)}"
  puts "Part 2: #{part2(3_014_603)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(3, part1(5))
  end

  def test_part2
    assert_equal(2, part2(5))
  end
end
