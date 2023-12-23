#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'pqueue'
require 'minitest/autorun'

class GraphNode
  attr_accessor :start, :finish

  def initialize(node, edges)
    @node = node
    @edges = edges
    @start = false
    @finish = false

    @@all ||= {}
    @@all[node] = self
  end

  def self.clear
    @@all = {}
  end

  def dfs(current_distance, max_distance, visited)
    return current_distance if @finish

    @edges.each do |n, d|
      n = @@all[n]
      next if visited.include?(n)
      new_d = n.dfs(current_distance + d, max_distance, visited.dup.add(n))
      max_distance = new_d if new_d > max_distance
    end
    max_distance
  end

  def self.max_distance
    Node.edges
    @@all.values.find(&:start).dfs(0, 0, Set.new)
  end
end

class Node
  attr_reader :x, :y, :type

  def initialize(x, y, type)
    @x = x
    @y = y
    @type = type

    @@all ||= {}
    @@all[@y] ||= {}
    @@all[@y][@x] = self
  end

  def self.find(x, y)
    return unless @@all[y]
    @@all[y][x]
  end

  def self.clear
    @@all = {}
  end

  def up
    self.class.find(x, y - 1)
  end

  def down
    self.class.find(x, y + 1)
  end

  def left
    self.class.find(x - 1, y)
  end

  def right
    self.class.find(x + 1, y)
  end

  def inspect
    "<Node:#{object_id} x=#{x} y=#{y}>"
  end

  def adjacent
    @adjacent ||= case type
    when 'v'
      [down]
    when '^'
      [up]
    when '>'
      [right]
    when '<'
      [left]
    else
      [up, down, left, right]
    end.compact
  end

  def self.walk(start, finish)
    pq = PQueue.new([[[start].to_set, 0, start]]) { _1[1] < _2[1] }
    results = []
    while !pq.empty?
      path, len, last = pq.pop
      if (path & finish).any?
        results << path
        next
      end

      last.adjacent.each do |dest|
        new_path = path.dup.add(dest)
        pq << [new_path, len + 1, dest] unless path.include?(dest)
      end
    end
    results
  end

  def self.edges
    start = @@all[@@all.keys.first].first.last
    finish = @@all[@@all.keys.last].first.last
    intersections = @@all.values.flat_map(&:values).select { _1.adjacent.count > 2 }
    intersections.push start, finish

    edges = Set.new

    intersections.each do |node|
      potential_dest = intersections.dup
      potential_dest.delete node
      paths = walk(node, potential_dest).map do |set|
        [node, (set & potential_dest).first].sort_by(&:object_id).push(set.count - 1)
      end
      gn = GraphNode.new(node, paths.map { |p| [p.first(2).reject { _1 == node }.first, p.last] })
      gn.start = true if node == start
      gn.finish = true if node == finish
      paths.each { edges << _1 }
    end
    edges
  end

  def self.graph
    puts "\n\ngraph {"
    edges.each do |n1, n2, dist|
      puts "\"#{n1.x},#{n1.y}\" -- \"#{n2.x},#{n2.y}\" [label=#{dist}]"
    end
    puts "}"
  end
end

def parse(file, unidirectional = true)
  file.lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |type, x|
      next if type == '#'
      n = Node.new(x, y, unidirectional ? type : '.')
    end
  end
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 1: #{GraphNode.max_distance}"

  Node.clear
  GraphNode.clear
  parse(File.read('input'), false)
  puts "Part 2: #{GraphNode.max_distance}"
end

class MyTest < Minitest::Test
  def setup
    Node.clear
    GraphNode.clear
  end

  def test_walk
    parse(File.read('sample'))
    assert_equal(94, GraphNode.max_distance)
  end

  def test_part2
    parse(File.read('sample'), false)
    assert_equal(154, GraphNode.max_distance)
  end
end

