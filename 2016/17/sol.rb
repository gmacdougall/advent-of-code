#! /usr/bin/env ruby
# frozen_string_literal: true

require 'digest/md5'

class Node
  def initialize(x, y)
    @x = x
    @y = y
    @@all ||= {}
    @@all[[x, y]] = self
  end

  attr_reader :x, :y

  def self.all = @@all
  def self.reset = @@all = {}
  def self.find(x, y)
    return nil unless (0..3).cover?(x) && (0..3).cover?(y)
    @@all[[x, y]] || Node.new(x, y)
  end

  def up = self.class.find(x, y - 1)
  def down = self.class.find(x, y + 1)
  def left = self.class.find(x - 1, y)
  def right = self.class.find(x + 1, y)

  def options(key)
    open = Digest::MD5.hexdigest(key).chars.first(4).map { ('b'..'f').cover?(it) || nil }
    can_up, can_down, can_left, can_right = open
    [
      can_up && up && :up,
      can_down && down && :down,
      can_left && left && :left,
      can_right && right && :right,
    ].compact
  end
end

DIR_TO_STR = {
  up: 'U',
  down: 'D',
  left: 'L',
  right: 'R',
}.freeze

def part1(key)
  start = Node.new(0, 0)
  dest = Node.new(3, 3)
  queue = [[start, '']]

  while queue.any?
    node, path = queue.shift
    return path if node == dest

    options = node.options("#{key}#{path}")
    options.each do |opt|
      queue << [node.public_send(opt), "#{path}#{DIR_TO_STR[opt]}"]
    end
  end

  fail
end

def part2(key)
  start = Node.new(0, 0)
  dest = Node.new(3, 3)
  queue = [[start, '']]

  longest = -1

  while queue.any?
    node, path = queue.shift
    if node == dest
      longest = path.length
    else
      options = node.options("#{key}#{path}")
      options.each do |opt|
        queue << [node.public_send(opt), "#{path}#{DIR_TO_STR[opt]}"]
      end
    end
  end

  longest
end

puts "Part 1: #{part1('bwnlcvfs')}"
puts "Part 2: #{part2('bwnlcvfs')}"

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal('DDRRRD', part1('ihgpwlah'))
    assert_equal('DDUDRLRRUDRD', part1('kglvqrro'))
    assert_equal('DRURDRUDDLLDLUURRDULRLDUUDDDRR', part1('ulqzkmiv'))
  end

  def test_part2
    assert_equal(370, part2('ihgpwlah'))
    assert_equal(492, part2('kglvqrro'))
    assert_equal(830, part2('ulqzkmiv'))
  end
end
