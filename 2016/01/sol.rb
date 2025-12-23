#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def part1(input)
  x = y = 0
  dir_mod = [[0, -1], [1, 0], [0, 1], [-1, 0]]

  input.split(', ').each do |inst|
    dir = inst[0]
    num = inst[1..].to_i

    dir_mod.rotate!(dir == 'R' ? 1 : -1)
    dx, dy = dir_mod.first
    x += dx * num
    y += dy * num
  end
  x.abs + y.abs
end

def part2(input)
  visited = Set.new
  x = y = 0
  dir_mod = [[0, -1], [1, 0], [0, 1], [-1, 0]]

  input.split(', ').each do |inst|
    dir = inst[0]
    num = inst[1..].to_i

    dir_mod.rotate!(dir == 'R' ? 1 : -1)
    dx, dy = dir_mod.first
    num.times do
      x += dx
      y += dy
      return x.abs + y.abs if visited.include?([x, y])
      visited << [x, y]
    end
  end
  fail
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input'))}"
  puts "Part 2: #{part2(File.read('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(5, part1('R2, L3'))
    assert_equal(2, part1('R2, R2, R2'))
    assert_equal(12, part1('R5, L5, R5, R3'))
  end

  def test_part2
    assert_equal(4, part2('R8, R4, R4, R8'))
  end
end
