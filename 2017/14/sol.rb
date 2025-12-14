#! /usr/bin/env ruby
# frozen_string_literal: true

require 'securerandom'

class Node
  def initialize(x, y)
    @x = x
    @y = y
    @group = nil
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :group

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]]

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]

  def used? = used
  def adjacent = [up, down, left, right].compact

  def visit(group = SecureRandom.uuid)
    return if @group
    @group = group
    adjacent.reject(&:group).each { it.visit(group) }
  end
end


def parse(fname)
  File.read(fname).split(',').map(&:to_i)
end

def go(input, times, size = 256)
  arr = Array.new(size) { _1 }
  pos = 0
  skip_size = 0

  times.times do
    input.each do |len|
      start = pos
      finish = (pos + len - 1) % size
      (len / 2).times do
        tmp = arr[start]
        arr[start] = arr[finish]
        arr[finish] = tmp

        start = (start + 1) % size
        finish = (finish - 1) % size
      end

      pos = (pos + len + skip_size) % size
      skip_size += 1 end
  end
  arr
end

def knot_hash(input)
  instructions = input.strip.chars.map(&:ord) + [17, 31, 73, 47, 23]
  go(instructions, 64, 256).each_slice(16).map { it.inject(:^).to_s(16).rjust(2, '0') }.join
end

def grid(str)
  128.times.map do |n|
    knot_hash("#{str}-#{n}").chars.map { it.to_i(16).to_s(2).rjust(4, '0') }.join
  end
end

def part1(str)
  grid(str).flatten.join.chars.count { it == '1' }
end

def part2(str)
  Node.reset
  grid(str).each_with_index do |line, y|
    line.chars.each_with_index do |chr, x|
      Node.new(x, y) if chr == '1'
    end
  end

  Node.all.values.each(&:visit)
  Node.all.values.map(&:group).uniq.size
end

puts "Part 1: #{part1('oundnydw')}"
puts "Part 2: #{part2('oundnydw')}"

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(8108, part1('flqrgnkx'))
  end

  def test_part2
    assert_equal(1242, part2('flqrgnkx'))
  end
end
