#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

$x_vals = []
$y_vals = []

class Node
  def initialize(x, y)
    @x = x
    @y = y
    @color = nil
    @@all[[x, y]] = self
  end

  attr_reader :x, :y
  attr_accessor :color

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]]

  def up = self.class.find(x, $y_vals[$y_vals.index(y) - 1])
  def down = self.class.find(x, $y_vals[$y_vals.index(y) + 1])
  def left = self.class.find($x_vals[$x_vals.index(x) - 1], y)
  def right = self.class.find($x_vals[$x_vals.index(x) + 1], y)
  def adjacent = [up, down, left, right].compact

  def self.print
    $y_vals.each do |y|
      foo = $x_vals.map do |x|
        node = find(x, y)
        case node.color
        when :green
          'G'
        when :red
          'R'
        when :black
          ' '
        else
          '#'
        end
      end
      puts foo.join
    end
  end

  def invalidate
    return if @color
    @color = :black
    adjacent.each { $to_invalidate << it unless it.color }
  end
end


def parse(fname)
  File.read(fname).lines(chomp: true).map { it.split(',').map(&:to_i) }
end

def part1(input)
  input.combination(2).map do |(a,b), (x,y)|
    (a - x + 1).abs * (b - y + 1).abs
  end.max
end

def part2(input)
  Node.reset
  $to_invalidate = Set.new
  $x_vals = input.map(&:first).uniq.sort
  $y_vals = input.map(&:last).uniq.sort

  $x_vals.each do |x|
    $y_vals.each do |y|
      Node.new(x, y)
    end
  end

  (input + [input.first]).each_cons(2) do |(a, b), (x, y)|
    Node.find(a, b).color = :red
    Node.find(x, y).color = :red

    if a == x
      from, to = [b, y].minmax
      ((from + 1)...to).select { $y_vals.include?(it) }.each do |ny|
        Node.find(x, ny).color = :green
      end
    elsif b == y
      from, to = [a, x].minmax
      ((from + 1)...to).select { $x_vals.include?(it) }.each do |nx|
        Node.find(nx, y).color = :green
      end
    else
      fail
    end
  end

  $x_vals.minmax.each do |x|
    $y_vals.each do |y|
      $to_invalidate << Node.find(x, y)
    end
  end

  $x_vals.each do |x|
    $y_vals.minmax.each do |y|
      $to_invalidate << Node.find(x, y)
    end
  end

  while $to_invalidate.any?
    node = $to_invalidate.first
    $to_invalidate.delete(node)
    node.invalidate
  end

  count = input.combination(2).size
  i = 0

  input.combination(2).map do |(a,b), (x,y)|
    i += 1
    puts "Computing #{i}/#{count}"
    x_range = Range.new(*[a,x].sort)
    y_range = Range.new(*[b,y].sort)

    valid = $x_vals.select { x_range.cover?(it) }.all? do |cx|
      $y_vals.select { y_range.cover?(it) }.all? do |cy|
        Node.find(cx, cy).color != :black
      end
    end

    valid ? x_range.size * y_range.size : 0
  end.max
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(50, part1(parse('sample')))
  end

  def test_part2
    # assert_equal(24, part2(parse('sample')))
  end
end
