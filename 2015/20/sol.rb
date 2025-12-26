#! /usr/bin/env ruby
# frozen_string_literal: true

require 'prime'

def fac_sum(n)
  n.prime_division.inject(1) do |acc, (p, m)|
    acc * (p**(m + 1) - 1) / (p - 1)
  end
end

def part1
  target = File.read('input').to_i / 10

  (2..).each do |n|
    result = fac_sum(n)
    return n if result >= target
  end
end

# Takes 2 minutes but it works
def part2
  target = File.read('input').to_i
  hash = Hash.new(0)
  (1..(target / 11)).each do |n|
    (1..50).each do |t|
      house = n * t
      hash[house] += 11 * n
    end
  end
  hash.select { _2 > target }.min_by(&:first).first
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
