#! /usr/bin/env ruby
# frozen_string_literal: true

def mix(value, secret) = value ^ secret
def prune(num) = num % 16_777_216

def rand(secret)
  secret = prune(mix(secret * 64, secret))
  secret = prune(mix(secret / 32, secret))
  prune(mix(secret * 2048, secret))
end

def parse(fname) = File.read(fname).lines.map(&:to_i)

def part1(input)
  input.sum do |secret|
    2000.times { secret = rand(secret) }
    secret
  end
end

def part2(input)
  result = input.map { |secret| Array.new(2000) { secret = rand(secret) } }.map { |a| a.map { _1 % 10 } }
  diffs = result.map { |a| a.each_cons(2).map { _2 - _1 }.each_cons(4) }

  totals = Hash.new(0)
  diffs.each_with_index do |diff, idx|
    done = Set.new
    diff.each_with_index do |d, i2|
      next if done.include?(d)

      totals[d] += result[idx][i2 + 4]
      done << d
    end
  end
  totals.values.max
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_sequence
    arr = [
      123,
      15_887_950,
      16_495_136,
      527_345,
      704_524,
      1_553_684,
      12_683_156,
      11_100_544,
      12_249_484,
      7_753_432,
      5_908_254
    ]
    arr.each_cons(2).each do |a, b|
      assert_equal(b, rand(a))
    end
  end

  def test_part1
    assert_equal(37_327_623, part1(parse('sample')))
  end

  def test_part2
    # assert_equal(23, part2(parse('sample2')))
  end
end
