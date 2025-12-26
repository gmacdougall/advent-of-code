#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true)
end

class Circuit
  def initialize(instructions)
    @instruction_set = parse(instructions)
  end

  attr_reader :instruction_set

  def resolve(var)
    reset_cache
    evaluate(instruction_set[var])
  end

  def reset_cache = @cache = {}

  private

  attr_reader :cache

  def evaluate(expr)
    return cache[expr] if cache.key?(expr)
    val = (
      if expr.include?('AND')
        left, right = expr.split(' AND ')
        evaluate(left) & evaluate(right)
      elsif expr.include?('OR')
        left, right = expr.split(' OR ')
        evaluate(left) | evaluate(right)
      elsif expr.include?('LSHIFT')
        left, right = expr.split(' LSHIFT ')
        evaluate(left) << Integer(right)
      elsif expr.include?('RSHIFT')
        left, right = expr.split(' RSHIFT ')
        evaluate(left) >> Integer(right)
      elsif expr.include?('NOT')
        ~evaluate(expr.sub('NOT ', ''))
      elsif expr.match?(/\d+/)
        Integer(expr)
      else
        evaluate(instruction_set[expr])
      end
    )
    cache[expr] = val & 65535
  end

  def parse(input)
    input.map do |line|
      left, right = line.split(' -> ')
      [right, left]
    end.sort.to_h
  end
end

if File.exist?('input')
  circuit = Circuit.new(parse('input'))
  a = circuit.resolve('a')
  puts "Part 1: #{a}"
  circuit.instruction_set['b'] = a.to_s
  circuit.reset_cache
  puts "Part 2: #{circuit.resolve('a')}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    circuit = Circuit.new(parse('sample'))
    expected = {
      d: 72,
      e: 507,
      f: 492,
      g: 114,
      h: 65412,
      i: 65079,
      x: 123,
      y: 456,
    }
    expected.each do |key, val|
      assert_equal(val, circuit.resolve(key.to_s))
    end
  end
end
