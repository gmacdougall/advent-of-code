#! /usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pry'
require 'z3'

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

  def self.part2
    solver = Z3::Solver.new

    px = Z3.Real('px')
    py = Z3.Real('py')
    pz = Z3.Real('pz')
    vx = Z3.Real('vx')
    vy = Z3.Real('vy')
    vz = Z3.Real('vz')

    @@all.each_with_index do |stone, idx|
      t = Z3.Real("t#{idx}")

      solver.assert(t > 0);
      solver.assert(px + vx * t == stone.px + stone.vx * t)
      solver.assert(py + vy * t == stone.py + stone.vy * t)
      solver.assert(pz + vz * t == stone.pz + stone.vz * t)
    end

    fail unless solver.check == :sat
    (solver.model[px] + solver.model[py] + solver.model[pz]).simplify
  end
end

def parse(file)
  file.each_line { Hailstone.new(*_1.scan(/-?\d+/).map(&:to_i)) }
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 2: #{Hailstone.part2}"
end

class MyTest < Minitest::Test
  def setup
    Hailstone.clear
    parse(File.read('sample'))
  end

  def test_part1
    assert_equal(47, Hailstone.part2)
  end
end

