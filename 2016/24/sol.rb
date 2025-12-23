#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  def initialize(x, y, blocked, dest)
    @x = x
    @y = y
    @blocked = blocked
    @dest = dest
    @distance = nil
    @@all ||= {}
    @@all[[x, y]] = self
  end

  attr_reader :x, :y, :blocked, :dest
  attr_accessor :distance

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y) = @@all[[x, y]]
  def self.reset_distance
    all.values.each { it.distance = nil }
  end
  def self.points_of_interest = all.values.select(&:dest)

  def up = self.class.find(x, y - 1)
  def down = self.class.find(x, y + 1)
  def left = self.class.find(x - 1, y)
  def right = self.class.find(x + 1, y)

  def adjacent = [up, down, left, right].reject(&:blocked).compact

  def self.dump
    y_range = Range.new(*all.keys.map(&:last).minmax)
    x_range = Range.new(*all.keys.map(&:first).minmax)
    y_range.each do |y|
      x_range.each do |x|
        node = find(x, y)
        if node.blocked
          print '#'
        elsif node.dest
          print node.dest
        else
          print ' '
        end
      end
      puts ''
    end
  end
end

def parse(fname)
  Node.reset
  File.read(fname).lines(chomp: true).each_with_index.map do |line, y|
    line.chars.each_with_index do |chr, x|
      Node.new(x, y, chr == '#', chr != '#' && chr != '.' ? chr : nil)
    end
  end
end

def distance_between_points
  Node.points_of_interest.combination(2).map do |a, b|
    Node.reset_distance
    distance = 0
    a.distance = 0
    queue = [a]
    while !b.distance
      distance += 1
      queue = queue.flat_map do |node|
        node.adjacent.flat_map do |adj|
          next if adj.distance

          adj.distance = distance
          adj
        end
      end.compact
    end
    [[a.dest, b.dest].sort, b.distance]
  end.to_h
end

def part1
  distances = distance_between_points
  to_visit = Node.points_of_interest.map(&:dest) - ['0']
  to_visit.permutation.map do |order|
    order.unshift '0'
    order.each_cons(2).sum do |pair|
      distances[pair.sort]
    end
  end.min
end

def part2
  distances = distance_between_points
  to_visit = Node.points_of_interest.map(&:dest) - ['0']
  to_visit.permutation.map do |order|
    order.unshift '0'
    order.push '0'
    order.each_cons(2).sum do |pair|
      distances[pair.sort]
    end
  end.min
end

if File.exist?('sample')
  parse('sample')
  puts "Sample Part 1: #{part1}"
end

if File.exist?('input')
  parse('input')
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end
