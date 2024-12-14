#! /usr/bin/env ruby
# frozen_string_literal: true

class Robot
  attr_reader :px, :py, :vx, :vy, :x_size, :y_size

  def initialize(px, py, vx, vy, x_size, y_size)
    @px = px
    @py = py
    @vx = vx
    @vy = vy
    @x_size = x_size
    @y_size = y_size
  end

  def move
    @px = (px + vx) % x_size
    @py = (py + vy) % y_size
  end

  def left = (0..(x_size / 2 - 1))
  def right = ((x_size / 2 + 1)..x_size - 1)
  def top = (0..(y_size / 2 - 1))
  def bottom = ((y_size / 2 + 1)..y_size - 1)

  def left? = left.cover?(px)
  def right? = right.cover?(px)
  def top? = top.cover?(py)
  def bottom? = bottom.cover?(py)

  def quadrant
    return :top_left if left.cover?(px) && top.cover?(py)
    return :top_right if right.cover?(px) && top.cover?(py)
    return :bottom_left if left.cover?(px) && bottom.cover?(py)

    :bottom_right if right.cover?(px) && bottom.cover?(py)
  end
end

def parse(fname, x_size, y_size)
  File.read(fname).lines.map do |line|
    Robot.new(*line.match(/p=(\d+),(\d+) v=(.+),(.+)/).captures.map(&:to_i), x_size, y_size)
  end
end

def dump(robots)
  pos = Hash.new { |h, k| h[k] = Hash.new(0) }
  robots.each { pos[_1.py][_1.px] += 1 }

  103.times do |y|
    101.times do |x|
      val = pos[y][x]
      print val.zero? ? ' ' : val
    end
    print "\n"
  end
end

def part1(robots)
  100.times { robots.each(&:move) }
  robots.map(&:quadrant).compact.tally.values.inject(:*)
end

def part2(robots)
  (0..).each do |n|
    if robots.group_by(&:py).any? { |_, group| group.map(&:px).uniq.sort.each_cons(2).count { _1 + 1 == _2 } > 20 }
      dump(robots)
      return n
    end

    robots.each(&:move)
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input', 101, 103))}"
  puts "Part 2: #{part2(parse('input', 101, 103))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(12, part1(parse('sample', 11, 7)))
  end
end
