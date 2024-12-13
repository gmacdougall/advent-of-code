#! /usr/bin/env ruby
# frozen_string_literal: true

class ClawMachine
  attr_reader :ax, :ay, :bx, :by, :tx, :ty

  def initialize(ax, ay, bx, by, tx, ty)
    @ax = ax
    @ay = ay
    @bx = bx
    @by = by
    @tx = tx
    @ty = ty
  end

  def increment_target
    @tx += 10_000_000_000_000
    @ty += 10_000_000_000_000
  end

  def cost
    pb = ((ty * ax) - (tx * ay)).to_f / ((ax * by) - (ay * bx))
    pa = (tx - (pb * bx)).to_f / ax
    pa == pa.to_i ? (pa * 3 + pb).to_i : 0
  end
end

def parse(fname)
  File.read(fname).split("\n\n").map do |str|
    matches = str.match(/Button A: X(.*), Y(.*)\nButton B: X(.*), Y(.*)\nPrize: X=(\d+), Y=(\d+)/)
    ClawMachine.new(*matches.captures.map(&:to_i))
  end
end

def part1(input)
  input.sum(&:cost)
end

def part2(input)
  input.each(&:increment_target).sum(&:cost)
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(480, part1(parse('sample')))
  end
end
