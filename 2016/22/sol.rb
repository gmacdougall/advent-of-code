#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, size, used, _, _)
    @x = x
    @y = y
    @size = size
    @used = used
    @goal = false
    @@all ||= {}
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :size
  attr_accessor :goal, :used

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]]

  def up = self.class.find(x, y - 1)
  def down = self.class.find(x, y + 1)
  def left = self.class.find(x - 1, y)
  def right = self.class.find(x + 1, y)

  def empty? = used == 0
  def adjacent = [up, down, left, right].compact
  def available = size - used

  def valid?
    used <= size
  end

  def swap(other)
    other.used, @used = @used, other.used
    other.goal, @goal = @goal, other.goal
    raise if !other.valid? || !valid?
  end

  def self.dump
    y_range = Range.new(*all.keys.map(&:last).minmax)
    x_range = Range.new(*all.keys.map(&:first).minmax)
    y_range.each do |y|
      x_range.each do |x|
        node = find(x, y)
        if node.goal
          print 'G'
        elsif node.size > 100
          print '#'
        elsif node.used.zero?
          print '_'
        else
          print '.'
        end
      end
      puts ''
    end
  end
end

def parse(fname)
  Node.reset
  File.read(fname).lines(chomp: true)[2..].map do |line|
    Node.new(*line.scan(/\d+/).map(&:to_i))
  end
end

def part1
  Node.all.values.permutation(2).count do |a, b|
    !a.empty? && a.used < b.available
  end
end

DIR = {
  'u' => :up,
  'd' => :down,
  'l' => :left,
  'r' => :right,
}

def part2
  Node.find(36, 0).goal = true
  str = ('uuulllllluurrrrrrrrrrrrrrrrrrrrru' + 'rdllu' * 35 + 'r')
  str.chars.each do |chr|
    dir = DIR[chr]
    empty = Node.all.values.find { it.used.zero? }
    empty.swap(empty.public_send(dir))
  end
  Node.dump
  str.length
end

if File.exist?('input')
  parse('input')
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end
