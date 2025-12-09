#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'
require 'set'

$x_vals = []
$y_vals = []

class Square
  def initialize(a, b)
    @a = a
    @b = b
  end

  attr_reader :a, :b

  def x_range = @x_range ||= Range.new(*[a.x, b.x].sort)
  def y_range = @y_range ||= Range.new(*[a.y, b.y].sort)

  def x_vals_to_check = @x_vals_to_check ||= $x_vals.select { x_range.cover?(it) }
  def y_vals_to_check = @y_vals_to_check ||= $y_vals.select { y_range.cover?(it) }

  def size = x_range.size * y_range.size

  # It is valid if all the values around the border are red or green (i.e not black)
  def valid?
    y_vals_to_check.all? do |y|
      x_vals_to_check.minmax.all? do |x|
        Node.find(x, y).color != :black
      end
    end && (
      x_vals_to_check.all? do |x|
        y_vals_to_check.minmax.all? do |y|
          Node.find(x, y).color != :black
        end
      end
    )
  end
end

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

  def invalidate(set)
    return if @color
    @color = :black
    adjacent.each { set << it unless it.color }
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

  # Set a global of the values listed in the input to limit the size of what
  # we need to look at in our node map
  $x_vals = input.map(&:first).uniq.sort
  $y_vals = input.map(&:last).uniq.sort

  $x_vals.each do |x|
    $y_vals.each do |y|
      Node.new(x, y)
    end
  end

  # Colour the spaces between green
  (input + [input.first]).each_cons(2) do |(a, b), (x, y)|
    Node.find(a, b).color = :red
    Node.find(x, y).color = :red

    if a == x
      range = Range.new(*[b, y].minmax)
      $y_vals.select { range.cover? it }.each do |ny|
        Node.find(x, ny).color ||= :green
      end
    elsif b == y
      range = Range.new(*[a, x].minmax)
      $x_vals.select { range.cover? it }.each do |nx|
        Node.find(nx, y).color ||= :green
      end
    else
      fail
    end
  end

  # Invalidate all elements around the edge
  to_invalidate = Set.new(
    $x_vals.minmax.flat_map { |x| $y_vals.map { |y| Node.find(x, y) } } +
    $y_vals.minmax.flat_map { |y| $x_vals.map { |x| Node.find(x, y) } }
  )

  while to_invalidate.any?
    node = to_invalidate.first
    to_invalidate.delete(node)
    node.invalidate(to_invalidate)
  end

  # Form a priority queue of squares to find the largest
  red_squares = Node.all.values.select { it.color == :red }
  pq = PQueue.new(red_squares.combination(2).map { Square.new(_1, _2) }) { _1.size > _2.size }

  while square = pq.pop
    return square.size if square.valid?
  end
  fail
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
    assert_equal(24, part2(parse('sample')))
  end
end
