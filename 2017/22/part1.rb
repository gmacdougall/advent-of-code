#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, chr = nil)
    @x = x
    @y = y
    @infected = chr == '#'
    @made_infected = 0
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :infected, :made_infected

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]] || Node.new(x, y)

  def up = self.class.find(x, y - 1)
  def down = self.class.find(x, y + 1)
  def left = self.class.find(x - 1, y)
  def right = self.class.find(x + 1, y)

  def toggle_infected
    @infected = !infected
    @made_infected += 1 if infected
  end
end

def parse(fname)
  Node.reset
  all = File.read(fname).lines(chomp: true)
  size = all.size
  all.each_with_index do |line, y|
    line.chars.each_with_index do |chr, x|
      Node.new(x - (size / 2), y - (size / 2), chr)
    end
  end
end

def part1
  dir = %i[up right down left]
  curr = Node.find(0, 0)
  10_000.times do
    dir.rotate!(curr.infected ? 1 : -1)
    curr.toggle_infected
    curr = curr.public_send(dir.first)
  end
  Node.all.values.sum(&:made_infected)
end

if File.exist?('input')
  parse('input')
  puts "Part 1: #{part1}"
  #puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse('sample')
    assert_equal(5587, part1)
  end
end
