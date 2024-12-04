#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map(&:strip).map(&:chars)
end

def part1(input)
  input.each_with_index.sum do |line, y|
    line.each_with_index.sum do |_, x|
      (-1..1).sum do |dy|
        (-1..1).count do |dx|
          'XMAS'.chars.each_with_index.all? do |match, dm|
            tx = (dm * dx) + x
            ty = (dm * dy) + y

            tx.between?(0, line.size - 1) && ty.between?(0, input.size - 1) && input[ty][tx] == match
          end
        end
      end
    end
  end
end

def part2(input)
  result = Hash.new(0)
  input.each_with_index do |line, y|
    line.each_with_index do |_, x|
      [-1, 1].each do |dy|
        [-1, 1].each do |dx|
          next unless 'MAS'.chars.each_with_index.all? do |match, dm|
            tx = (dm * dx) + x
            ty = (dm * dy) + y

            tx.between?(0, line.size - 1) && ty.between?(0, input.size - 1) && input[ty][tx] == match
          end

          result[[x + dx, y + dy]] += 1
        end
      end
    end
  end
  result.values.count { _1 == 2 }
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(18, part1(parse('sample')))
  end

  def test_part2
    assert_equal(9, part2(parse('sample')))
  end
end
