#! /usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Particle
  def initialize(id, pos, vel, accel)
    @id = id
    @pos = pos
    @vel = vel
    @accel = accel
    @destroyed = false
  end

  attr_reader :id, :pos, :vel, :accel, :destroyed

  def go
    @vel += accel
    @pos += vel
  end

  def dist
    pos.map(&:abs).sum
  end

  def destroy
    @destroyed = true
  end

  def self.parse(id, str)
    new(id, *str.scan(/\<(.*?)\>/).flatten.map { Vector[*it.split(',').map(&:to_i)] })
  end
end

def parse(fname)
  File.read(fname).lines.each_with_index.map { Particle.parse(_2, _1.strip) }
end

def part1(input)
  500.times { input.each(&:go) }
  input.min_by(&:dist).id
end

def part2(input)
  500.times do
    positions = input.reject(&:destroyed).map(&:pos)
    positions.tally.select { _2 > 1 }.each do |pos, _|
      input.select { it.pos == pos }.each(&:destroy)
    end
    input.each(&:go)
  end
  input.reject(&:destroyed).count
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end
