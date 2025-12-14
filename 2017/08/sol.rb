#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).map(&:split)
end

def part1(input)
  registers = Hash.new(0)
  input.each do |op_var, op, op_val, _, cond_var, cond, cond_val|
    if registers[cond_var].public_send(cond.to_sym, cond_val.to_i)
      if op == 'inc'
        registers[op_var] += op_val.to_i
      else
        registers[op_var] -= op_val.to_i
      end
    end
  end
  registers.values.max
end

def part2(input)
  registers = Hash.new(0)
  max = -1
  input.each do |op_var, op, op_val, _, cond_var, cond, cond_val|
    if registers[cond_var].public_send(cond.to_sym, cond_val.to_i)
      if op == 'inc'
        registers[op_var] += op_val.to_i
      else
        registers[op_var] -= op_val.to_i
      end
    end
    max = [max, registers.values.max].compact.max
  end
  max
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(1, part1(parse('sample')))
  end

  def test_part2
    assert_equal(10, part2(parse('sample')))
  end
end
