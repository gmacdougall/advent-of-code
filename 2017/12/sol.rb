#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  Node.reset
  File.read(fname).lines.each do |line|
    id, adjacent = line.split(' <-> ')
    Node.new(id.to_i, adjacent.split(', ').map(&:to_i))
  end
  visit_all
end

class Node
  def initialize(id, adjacent)
    @id = id
    @adjacent = adjacent
    @group = nil
    @@all ||= {}
    @@all[id] = self
  end

  attr_reader :id, :group

  def self.all = @@all
  def self.values = @@all.values
  def self.reset = @@all = {}
  def self.find(x) = @@all[x]

  def neighbours
    @adjacent.map { self.class.find it }
  end

  def visit(n)
    @group = n
    neighbours.reject(&:group).each { _1.visit(n) }
  end
end

def visit_all
  n = 0
  while Node.values.any? { _1.group.nil? }
    node = Node.values.select { _1.group.nil? }.sample
    node.visit(n)
    n += 1
  end
  Node.values.map(&:group).uniq.size
end

def part1
  Node.values.map(&:group).tally[Node.find(0).group]
end

def part2
  Node.values.map(&:group).uniq.size
end

if File.exist?('input')
  parse('input')
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse 'sample'
    assert_equal(6, part1)
  end

  def test_part2
    parse('sample')
    assert_equal(2, part2)
  end
end
