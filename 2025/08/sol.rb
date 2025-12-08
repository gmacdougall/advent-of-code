#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require 'securerandom'

class Box
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
    @connections = []
    @identity = nil
  end

  attr_reader :x, :y, :z, :connections
  attr_accessor :identity

  def distance(other)
    Math.sqrt((other.x - x)**2 + (other.y - y)**2 + (other.z - z)**2)
  end

  def inspect
    "<Box x=#{x} y=#{y} z=#{z} conn=#{connections}>"
  end

  def identify_circuit(uuid = nil)
    return if @identity

    uuid ||= SecureRandom.uuid
    @identity = uuid
    @connections.each { it.identify_circuit uuid }
  end
end

def parse(fname)
  File.read(fname).lines.map { Box.new(*it.scan(/\d+/).map(&:to_i)) }
end

def part1(input, steps)
  foo = input.combination(2).map do |a, b|
    [a, b, a.distance(b)]
  end.sort_by(&:last)

  while steps > 0
    a, b, *_ = foo.shift

    if !a.connections.include?(b)
      a.connections << b
      b.connections << a
      steps -= 1
    end
  end

  input.each(&:identify_circuit)
  input.map(&:identity).tally.map(&:last).sort.last(3).inject(:*)
end

def part2(input)
  foo = input.combination(2).map do |a, b|
    [a, b, a.distance(b)]
  end.sort_by(&:last)

  loop do
    a, b, *_ = foo.shift

    if !a.connections.include?(b)
      a.connections << b
      b.connections << a
    end
    input.each { it.identity = nil }
    input.each(&:identify_circuit)

    if input.map(&:identity).tally.size == 1
      return a.x * b.x
    end
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'), 1000)}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(40, part1(parse('sample'), 10))
  end

  def test_part1
    assert_equal(25272, part2(parse('sample')))
  end
end
