#! /usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

class Node
  def initialize(val)
    @val = val
  end

  attr_reader :val
  attr_accessor :right

  def inspect
    "<Node val=#{val} right=#{right&.val}>"
  end
end

def part1(steps)
  curr = Node.new(0)
  start = curr
  curr.right = curr

  (1..2017).each do |n|
    steps.times { curr = curr.right }
    to_add = Node.new(n)
    to_add.right = curr.right
    curr.right = to_add
    curr = to_add
  end
  curr.right.val
end

def part2(steps)
  curr = Node.new(0)
  start = curr
  curr.right = curr

  (1..50_000_000).each do |n|
    steps.times { curr = curr.right }
    to_add = Node.new(n)
    to_add.right = curr.right
    curr.right = to_add
    curr = to_add
    puts n if (n % 100_000).zero?
  end
  start.right.val
end

puts "Part 1: #{part1(316)}"
# This takes a while but it works...
puts "Part 2: #{part2(316)}"

class MyTest < Minitest::Test
  def test_part1
    #assert_equal(638, part1(3))
  end
end
