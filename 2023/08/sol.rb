#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  attr_reader :name

  def initialize(name, left, right)
    @@all ||= {}
    @name = name
    @left = left
    @right = right
    @@all[name] = self
  end

  def self.clear
    @@all = {}
  end

  def self.starting_nodes
    @@all.keys.select { _1.end_with?('A') }.map { find _1 }
  end

  def self.find(name)
    @@all[name]
  end

  def ending_node?
    @ending_node ||= name.end_with?('Z')
  end

  def L
    @@all[@left]
  end

  def R
    @@all[@right]
  end
end

def parse(file)
  instructions, _, *node_defs = file.lines.map(&:strip)
  node_defs.each { Node.new(*_1.scan(/\w{3}/)) }
  instructions.chars
end

def walk(start, instructions)
  steps = 0
  curr = start
  len = instructions.count
  loop do
    curr = curr.public_send(instructions[steps % len].to_sym)
    steps += 1
    return steps if curr.ending_node?
  end
end

def part1(instructions)
  walk(Node.find('AAA'), instructions)
end

def part2(instructions)
  Node.starting_nodes.map { |start| walk(start, instructions) }.reduce(1, :lcm)
end

if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2(input)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1_sample1
    assert_equal(2, part1(parse(File.read('sample1'))))
    Node.clear
  end

  def test_part1_sample2
    assert_equal(6, part1(parse(File.read('sample2'))))
    Node.clear
  end

  def test_part2
    assert_equal(6, part2(parse(File.read('sample3'))))
    Node.clear
  end
end
