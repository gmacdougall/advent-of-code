#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip).map(&:chars)

class Node
  attr_reader :x, :y, :seat
  attr_accessor :occupied

  @@all = {}

  def initialize(x, y, seat, occupied = false)
    @x = x
    @y = y
    @seat = seat
    @occupied = occupied
    @@all[y] ||= {}
    @@all[y][x] = self
  end

  def self.parse(x, y, str)
    seat = str == 'L'
    new(x, y, seat)
  end

  def self.all_nodes
    @@all.values.flat_map(&:values)
  end

  def self.print_all
    @@all.values.map do |row|
      row.values.map(&:to_s).join
    end.join("\n")
  end

  def self.tick
    state = all_nodes.map { |node| [node, node.adjacent.count(&:occupied)] }

    state.each do |node, count|
      if node.seat
        if node.occupied && count >= 5
          node.occupied = false
        elsif !node.occupied && count.zero?
          node.occupied = true
        end
      end
    end
  end

  def to_s
    if occupied
      '#'
    elsif seat
      'L'
    else
      '.'
    end
  end

  def adjacent
    (-1..1).to_a.product((-1..1).to_a).reject { |x, y| x.zero? && y.zero? }.map do |x, y|
      mul = (1..1000).find do |multiplier|
        node = @@all.dig(@y + y * multiplier, @x + x * multiplier)
        node.nil? || node.seat
      end
      @@all.dig(@y + y * mul, @x + x * mul)
    end.compact
  end

  def inspect
    "<N:#{x},#{y} #{self}>"
  end
end

input.each_with_index do |row, y|
  row.each_with_index do |val, x|
    Node.parse(x, y, val)
  end
end

old = ''
new = Node.print_all
while new != old
  old = new
  Node.tick
  new = Node.print_all
end

p Node.all_nodes.count(&:occupied)
