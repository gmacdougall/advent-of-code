#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  Node.reset
  File.read(fname).lines.map do |line|
    foo, under = line.split('->')
    id, weight = foo.match(/(\w+) \((\d+)\)/).captures
    [
      id, 
      {
        weight: weight.to_i,
        under: under&.scan(/\w+/) || [],
      }
    ]
  end.to_h
end

class Node
  def initialize(name, weight, under)
    @name = name
    @weight = weight
    @under = under || []
    @@all ||= {}
    @@all[name] = self

    @tier = nil
    @total_weight = nil
  end

  attr_reader :name, :weight, :under, :tier

  def self.all = @@all
  def self.reset = @@all = {}

  def up
    @@all.values.find { it.under.include? name }
  end

  def down
    under.map { @@all[it] }
  end

  def total_weight(tier = 0)
    return @total_weight if @total_weight

    @tier = tier
    @total_weight = @weight + down.sum { it.total_weight(tier + 1) }
  end

  def unbalanced?
    down.size.positive? && down.map(&:total_weight).uniq.size > 1
  end
end

def part1(input)
  (input.keys - input.values.flat_map { it[:under] }.compact).first
end

def part2(input)
  input.each do |name, hash|
    Node.new(name, hash[:weight], hash[:under])
  end

  node = Node.all.values.first
  node = node.up while node.up

  node.total_weight

  to_fix = Node.all.values.select(&:unbalanced?).max_by(&:tier)
  incorrect, correct = to_fix.down.map(&:total_weight).tally.sort_by(&:last).map(&:first)
  really_fix = to_fix.down.find { it.total_weight == incorrect }

  return really_fix.weight - (incorrect - correct)
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal('tknk', part1(parse('sample')))
  end

  def test_part2
    assert_equal(60, part2(parse('sample')))
  end
end
