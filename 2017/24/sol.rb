#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map { _1.split('/').map(&:to_i) }.uniq
end

def go(input, path, right, result)
  nodes = input.select { |a, b| a == right || b == right }
  if nodes.empty?
    len = path.length
    sum = path.flatten.sum
    result[len] = sum if result[len] < sum
    return
  end

  nodes.each do |node|
    left = input.dup
    left.delete(node)

    other = node.index(right) == 0 ? 1 : 0
    new_right = node[other]
    go(left, path + [node], new_right, result)
  end
end

def call(input)
  result = Hash.new(0)
  go(input, [], 0, result)
  [result.values.max, result[result.keys.max]]
end

if File.exist?('input')
  part1, part2 = call(parse('input'))
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_call
    part1, part2 = call(parse('sample'))
    assert_equal(31, part1)
    assert_equal(19, part2)
  end
end
