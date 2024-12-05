#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  Number.reset
  rules_input, pages = File.read(fname).split("\n\n")
  rules_input.lines.map { |line| Number.add_dep(*line.strip.split('|').map(&:to_i)) }
  pages.lines.map { |line| line.strip.split(',').map { Number.new _1.to_i } }
end

class Number
  include Comparable

  attr_reader :n

  def initialize(n) = @n = n
  def self.reset = @@deps = Hash.new { |h, k| h[k] = [] }
  def self.add_dep(x, y) = @@deps[y] << x
  def <=>(other) = @@deps[n]&.include?(other.n) ? 1 : -1
end

def part1(input) = input.sum { _1 == _1.sort ? _1[_1.length / 2].n : 0 }
def part2(input) = input.sum { _1 == _1.sort ? 0 : _1.sort[_1.length / 2].n }

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(143, part1(parse('sample')))
  end

  def test_part2
    assert_equal(123, part2(parse('sample')))
  end
end
