#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'

POSSIBLE_TURNS = {
  up: %i[left right].freeze,
  down: %i[left right].freeze,
  left: %i[up down].freeze,
  right: %i[up down].freeze
}.freeze

class Node
  attr_reader :x, :y, :finish, :visited

  def initialize(x, y, finish: false)
    @x = x
    @y = y
    @finish = finish
    @visited = {
      up: Float::INFINITY,
      down: Float::INFINITY,
      left: Float::INFINITY,
      right: Float::INFINITY
    }

    @@all ||= {}
    @@all[@y] ||= {}
    @@all[@y][@x] = self
  end

  def self.find(x, y) = @@all.dig(y, x)
  def self.clear = @@all = {}
  def up = self.class.find(x, y - 1)
  def down = self.class.find(x, y + 1)
  def left = self.class.find(x - 1, y)
  def right = self.class.find(x + 1, y)

  def self.go(start)
    pq = PQueue.new([[0, start, :right, Set.new([start])]]) { |a, b| a.first < b.first }

    best_path = Set.new
    best_path_score = Float::INFINITY

    loop do
      score, node, facing, path = pq.pop

      break if score > best_path_score
      next if node.visited[facing] < score

      node.visited[facing] = score

      if node.finish
        best_path_score = score
        best_path.merge(path)
      end

      dest = node.public_send(facing)
      pq << [score + 1, dest, facing, path.dup.add(dest)] if dest

      POSSIBLE_TURNS[facing].each do |turn_dir|
        dest = node.public_send(turn_dir)
        pq << [score + 1000, node, turn_dir, path] if dest
      end
    end
    [best_path_score, best_path.size]
  end
end

def parse(fname)
  Node.clear
  start = nil
  File.read(fname).lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |type, x|
      next if type == '#'

      node = Node.new(x, y, finish: type == 'E')
      start = node if type == 'S'
    end
  end
  start
end

if File.exist?('input')
  part1, part2 = Node.go(parse('input'))
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    start = parse('sample')
    assert_equal(7036, Node.go(start).first)
  end

  def test_part1_sample2
    start = parse('sample2')
    assert_equal(11_048, Node.go(start).first)
  end

  def test_part2
    start = parse('sample')
    assert_equal(45, Node.go(start).last)
  end

  def test_part2_sample2
    start = parse('sample2')
    assert_equal(64, Node.go(start).last)
  end
end
