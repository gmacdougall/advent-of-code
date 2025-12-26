#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).scan(/\d+/).map(&:to_i)
end

def seq_order(row, col)
  v = (row + col) - 1
  (v**2 / 2) - (v / 2) + col
end

def part1(row, col)
  val = 20_151_125
  (seq_order(row, col) - 1).times do
    val *= 252_533
    val %= 33_554_393
  end
  val
end

puts "Part 1: #{part1(*parse('input'))}"
