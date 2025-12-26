#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).map do |line|
    a, _, b, _, dist = line.split(' ')
    [[a, b].sort, dist.to_i]
  end.to_h
end

def sol(input)
  cities = input.keys.flatten.uniq
  cities.permutation.map do |order|
    order.each_cons(2).sum do |a, b|
      input[[a, b].sort]
    end
  end.minmax
end

if File.exist?('input')
  part1, part2 = sol(parse('input'))
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(605, sol(parse('sample')).min)
  end
end
