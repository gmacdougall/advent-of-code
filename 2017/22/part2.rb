#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, state = :clean)
    @x = x
    @y = y
    @state = state
    @made_infected = 0
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :state, :made_infected

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]] || Node.new(x, y)

  def up = self.class.find(x, y - 1)
  def down = self.class.find(x, y + 1)
  def left = self.class.find(x - 1, y)
  def right = self.class.find(x + 1, y)

  def visit
    @state = case state
    when :clean
      :weakend
    when :weakend
      :infected
    when :infected
      :flagged
    when :flagged
      :clean
    else
      fail
    end
    @made_infected += 1 if state == :infected
  end
end

def parse(fname)
  Node.reset
  all = File.read(fname).lines(chomp: true)
  size = all.size
  all.each_with_index do |line, y|
    line.chars.each_with_index do |chr, x|
      Node.new(x - (size / 2), y - (size / 2), chr == '#' ? :infected : :clean)
    end
  end
end

def part2(steps = 10_000_000)
  dir = %i[up right down left]
  curr = Node.find(0, 0)
  steps.times do
    case curr.state
    when :clean
      dir.rotate!(-1)
    when :weakend
      # No-op
    when :infected
      dir.rotate!
    when :flagged
      dir.rotate!(2)
    else
      fail
    end
    curr.visit
    curr = curr.public_send(dir.first)
  end
  Node.all.values.sum(&:made_infected)
end

if File.exist?('input')
  parse('input')
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part2
    parse('sample')
    assert_equal(26, part2(100))
    parse('sample')
    assert_equal(2511944, part2)
  end
end
