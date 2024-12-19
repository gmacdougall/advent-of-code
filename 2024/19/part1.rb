#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  available, options = File.read(fname).split("\n\n")
  [
    available.strip.split(', ').map(&:chars),
    options.lines.map { _1.strip.chars }
  ]
end

def possible?(available, option, len = 0, tested = Set.new)
  return true if len == option.size
  return false if tested.include?(len)

  tested << len

  available.any? do |to_add|
    matches = to_add.each_with_index.all? do |chr, idx|
      option[idx + len] == chr
    end

    matches ? possible?(available, option, len + to_add.size, tested) : false
  end
end

def part1(available, options)
  options.count { |opt| possible?(available, opt) }
end

puts "Part 1: #{part1(*parse('input'))}" if File.exist?('input')

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(6, part1(*parse('sample')))
  end
end
