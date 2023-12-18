#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'

POSSIBLE_DIRECTIONS = {
  nil => %i[right down].freeze,
  up: %i[left right].freeze,
  down: %i[left right].freeze,
  left: %i[up down].freeze,
  right: %i[up down].freeze,
}.freeze

class Node
  attr_reader :x, :y, :num, :visited

  def initialize(num, x, y)
    @num = num
    @x = x
    @y = y

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

  def reset
    @visited = Hash.new { Float::INFINITY }
  end

  def up
    return if y == 0
    self.class.find(x, y - 1)
  end

  def down
    self.class.find(x, y + 1)
  end

  def left
    return if x == 0
    self.class.find(x - 1, y)
  end

  def right
    self.class.find(x + 1, y)
  end

  def self.reset
    @@all.values.map(&:values).flatten.each(&:reset)
  end

  def self.part1
    reset
    go(1..3)
  end

  def self.part2
    reset
    go(4..10)
  end

  def self.go(range)
    start = find(0,0)
    finish = find(@@all[0].keys.max, @@all.keys.max)

    pq = PQueue.new([[nil, 0, start]]) { _1[1] < _2[1] }

    while !pq.empty?
      last, dist, curr = pq.pop
      break if curr == finish

      POSSIBLE_DIRECTIONS[last].each do |dir|
        c = curr
        d = dist

        range.max.times do |len|
          c = c.public_send(dir)
          break unless c
          d += c.num
          next unless len >= (range.min - 1)
          if c.visited[dir] > len
            pq << [dir, d, c]
            c.visited[dir] = len
          end
        end
      end
    end
    dist
  end
end

def parse(file)
  file.lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |type, x|
      Node.new(Integer(type), x, y)
    end
  end
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 1: #{Node.part1}"
  puts "Part 2: #{Node.part2}"
  Node.clear
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse(File.read('sample'))
    assert_equal(102, Node.part1)
    Node.clear
  end

  def test_part2
    parse(File.read('sample'))
    assert_equal(94, Node.part2)
    Node.clear
  end
end
