#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, paper = false)
    @x = x
    @y = y
    @paper = paper
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :paper

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

  def paper? = paper
  def remove_paper = @paper = false
  def adjacent_paper = adjacent.count(&:paper?)
  def adjacent = [up, down, left, right, up_left, up_right, down_left, down_right].compact
end

def parse(fname)
  Node.reset
  File.read(fname).lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |chr, x|
      Node.new(x, y, chr == '@')
    end
  end
end

def part1
  Node.all.values.count { it.paper? && it.adjacent_paper < 4 }
end

def part2
  removed = 0
  loop do
    to_remove = Node.all.values.select { it.paper? && it.adjacent_paper < 4 }
    break if to_remove.empty?

    to_remove.each do |node|
      node.remove_paper
      removed += 1
    end
  end
  removed
end

if File.exist?('input')
  parse 'input'
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse 'sample'
    assert_equal(13, part1)
  end

  def test_part2
    parse 'sample'
    assert_equal(43, part2)
  end
end
