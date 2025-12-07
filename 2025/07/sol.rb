#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, split = false)
    @x = x
    @y = y
    @beam = false
    @split = split
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :split
  attr_accessor :beam

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]]

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]

  def activate
    raise unless @beam
    @beam = false

    dest = down
    return unless dest
    if dest.split
      $split += 1
      dest.left.beam = true
      dest.right.beam = true
    else
      dest.beam = true
    end
  end

  def part2
    return @cache if @cache
    return 1 unless down

    @cache = if down.split
      down.left.part2 + down.right.part2
    else
      down.part2
    end
  end
end

def parse(fname)
  $split = 0

  Node.reset
  File.read(fname).lines(chomp: true).each_with_index.map do |line, y|
    line.chars.each_with_index do |chr, x|
      node = Node.new(x, y, chr == '^')
      node.beam = true if chr == 'S'
    end
  end
end

def part1(input)
  beams = Node.all.each_value.select(&:beam)
  while beams.any?
    beams.each(&:activate)
    beams = Node.all.each_value.select(&:beam)
  end
  $split
end

def part2(input)
  Node.all.each_value.select(&:beam).first.part2
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(21, part1(parse('sample')))
  end

  def test_part2
    assert_equal(40, part2(parse('sample')))
  end
end
