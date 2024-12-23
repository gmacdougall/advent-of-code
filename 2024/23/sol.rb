#! /usr/bin/env ruby
# frozen_string_literal: true

class Computer
  def initialize(name)
    @name = name
    @@all ||= {}
    @@all[name] = self
    @links = Set.new
  end

  attr_reader :name, :links

  def self.all_values = @@all.values
  def self.reset = @@all = {}
  def self.find(name) = @@all[name] || Computer.new(name)

  def linked_names = @links.map(&:name) + [@name]
  def link(comp) = @links << comp

  def inspect = "<Computer name=#{name} links=#{@links.map(&:name).join(',')}>"

  def biggest_set
    possible_set = ([self] + @links.to_a).map(&:linked_names)
    linked_names.size.downto(1) do |size|
      max = possible_set.combination(size).find { _1.inject(:&).size == size }
      return max.inject(:&).sort.join(',') if max
    end
    nil
  end
end

def parse(fname)
  Computer.reset
  File.read(fname).lines.map(&:strip).map { _1.split('-') }.each do |name1, name2|
    ca = Computer.find(name1)
    cb = Computer.find(name2)
    ca.link(cb)
    cb.link(ca)
  end
end

def part1
  Computer.all_values.select { _1.name.start_with?('t') }.flat_map do |computer|
    computer.links.to_a.combination(2).select do |a, b|
      b.links.include?(a)
    end.map { |a| (a.map(&:name) + [computer.name]).sort }
  end.uniq.size
end

def part2
  Computer.all_values.flat_map(&:biggest_set).max_by(&:length)
end

if File.exist?('input')
  parse('input')
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse('sample')
    assert_equal(7, part1)
  end

  def test_part2
    parse('sample')
    assert_equal('co,de,ka,ta', part2)
  end
end
