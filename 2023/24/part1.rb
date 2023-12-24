#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'minitest/autorun'

class Hailstone
  attr_reader :px, :py, :pz, :vx, :vy, :vz

  def initialize(px, py, pz, vx, vy, vz)
    @px = px
    @py = py
    @pz = pz
    @vx = vx
    @vy = vy
    @vz = vz

    @@all ||= []
    @@all << self
  end

  def self.clear = @@all = []

  def m = vy.to_f / vx
  def b = py - (px * m)
  def future?(x) = vx > 0 ? x > px : x < px

  def intersect(stone)
    x = (stone.b - b)/(m - stone.m)
    y = (m * stone.b - stone.m * b)/(m - stone.m)
    [x, y]
  end

  def self.part1(range)
    @@all.combination(2).count do |one, two|
      x, y = one.intersect(two)
      range.cover?(x) && range.cover?(y) && one.future?(x) && two.future?(x)
    end
  end
end

def parse(file)
  file.each_line { Hailstone.new(*_1.scan(/-?\d+/).map(&:to_i)) }
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 1: #{Hailstone.part1(200_000_000_000_000..400_000_000_000_000)}"
end

class MyTest < Minitest::Test
  def setup
    Hailstone.clear
    parse(File.read('sample'))
  end

  def test_part1
    assert_equal(2, Hailstone.part1(7..27))
  end
end

