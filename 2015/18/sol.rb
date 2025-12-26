#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, on, sticky_on)
    @x = x
    @y = y
    @on = on || sticky_on
    @sticky_on = sticky_on || false
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :on

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]]

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]
  def up_left = @@all[[x - 1, y - 1]]
  def up_right = @@all[[x + 1, y - 1]]
  def down_left = @@all[[x - 1, y + 1]]
  def down_right = @@all[[x + 1, y + 1]]

  def adjacent = [up, down, left, right, up_left, up_right, down_left, down_right].compact

  def set_next
    adjacent_on = adjacent.count(&:on)
    @next = on ? adjacent_on == 2 || adjacent_on == 3 : adjacent_on == 3
  end

  def advance
    @on = @next || @sticky_on
  end
end

def parse(fname, sticky_on = false)
  Node.reset
  max = File.read(fname).lines.count - 1
  File.read(fname).lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |chr, x|
      Node.new(x, y, chr == '#', sticky_on && (x == 0 || x == max) && (y == 0 || y == max))
    end
  end
end

def solve(n)
  n.times do
    Node.all.values.each(&:set_next)
    Node.all.values.each(&:advance)
  end
  Node.all.values.count(&:on)
end

if File.exist?('input')
  parse 'input'
  puts "Part 1: #{solve(100)}"
  parse 'input', true
  puts "Part 2: #{solve(100)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse 'sample'
    assert_equal(4, solve(4))
  end

  def test_part2
    parse 'sample', true
    binding.irb
    assert_equal(17, solve(5))
  end
end
