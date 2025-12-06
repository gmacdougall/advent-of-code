#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { it.strip.split(/\s+/) }.transpose
end

def parse2(fname)
  File.read(fname).lines.map { it.sub("\n", '').chars }
end

def part1(input)
  input.sum do |list|
    *nums, op = list
    op = op.to_sym
    nums = nums.map(&:to_i)
    nums.inject op
  end
end

def part2(input)
  len = input.first.length
  input.each do |line|
    line << ' ' while line.length < len
  end
  total = 0

  op = nil
  numbers = []
  input.transpose.each do |line|
    if line.all? { it == ' ' }
      total += numbers.inject(op)
      numbers = []
      op = nil
      next
    end

    op ||= line.pop.to_sym
    numbers << line.join.to_i
  end
  total + numbers.inject(op)
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse2('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(4_277_556, part1(parse('sample')))
  end

  def test_part2
    assert_equal(3_263_827, part2(parse2('sample')))
  end
end
