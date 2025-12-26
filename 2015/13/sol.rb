#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).each_with_object(Hash.new(0)) do |line, hash|
    a, _, type, num, _, _, _, _, _, _, b = line.split
    num = num.to_i
    num = -num if type == 'lose'
    hash[[a, b.sub('.', '')].sort] += num
  end.to_h
end

def sol(input, people)
  people.permutation.map do |perm|
    perm.each_cons(2).sum do |a, b|
      input[[a, b].sort]
    end + input[[perm[0], perm[-1]].sort]
  end.max
end

def part1(input)
  people = input.keys.flatten.uniq
  sol(input, people)
end

def part2(input)
  people = input.keys.flatten.uniq + ['Me']
  sol(input, people)
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(330, part1(parse('sample')))
  end
end
