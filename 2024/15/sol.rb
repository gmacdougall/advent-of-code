#! /usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

class Node
  def initialize(x, y, type)
    @x = x
    @y = y
    @type = type
    @@all[[x, y]] = self
  end

  attr_reader :x, :y
  attr_accessor :type

  def self.all = @@all
  def self.reset = @@all = {}

  def self.dump
    Range.new(*@@all.keys.map(&:last).minmax).each do |y|
      Range.new(*@@all.keys.map(&:first).minmax).each do |x|
        print @@all[[x, y]].type
      end
      print "\n"
    end
  end

  def wall? = @type == '#'
  def box? = @type == 'O' || @type == '[' || @type == ']'
  def free? = @type == '.'

  def matching_box
    if @type == '['
      right
    elsif @type == ']'
      left
    end
  end

  def can_move?(dir, checked = [])
    return true if checked.include?(self)

    if %i[left right].include?(dir)
      dest = public_send(dir)
      dest = dest.public_send(dir) while dest.box?
      dest.free?
    else
      [self, matching_box].all? do |node|
        dest = node.public_send(dir)
        if dest.free?
          true
        elsif dest.wall?
          false
        else
          dest.can_move?(dir, checked + [self, matching_box])
        end
      end
    end
  end

  def move_box(dir, idx)
    if %i[left right].include?(dir)
      order = [self, matching_box].sort_by(&:x)
      order = order.reverse if dir == :right
      order.first.public_send(dir).move_box(dir, idx) if order.first.public_send(dir).box?

      order.each do |node|
        node.public_send(dir).type = node.type
      end
      order.last.type = '.'
    elsif can_move?(dir)
      [self, matching_box].each do |node|
        dest = node.public_send(dir)

        dest.move_box(dir, idx) if dest.box?
        dest.type = node.type
        node.type = '.'
      end
    end
  end

  def up = @@all[[x, y - 1]]
  def down = @@all[[x, y + 1]]
  def left = @@all[[x - 1, y]]
  def right = @@all[[x + 1, y]]
  def adjacent = [up, down, left, right]
end

def parse(fname, big: false)
  Node.reset
  map, instructions = File.read(fname).split("\n\n")
  map.lines.each_with_index do |line, y|
    if big
      line.gsub!('#', '##')
      line.gsub!('O', '[]')
      line.gsub!('.', '..')
      line.gsub!('@', '@.')
    end
    line.strip.chars.each_with_index do |char, x|
      Node.new(x, y, char)
    end
  end

  instructions.strip.gsub("\n", '').chars.map do |char|
    case char
    when '^'
      :up
    when 'v'
      :down
    when '<'
      :left
    when '>'
      :right
    else
      raise
    end
  end
end

def part1(input)
  robot = Node.all.values.find { _1.type == '@' }

  input.each do |dir|
    next if robot.public_send(dir).wall?

    if robot.public_send(dir).free?
      robot.type = '.'
      robot = robot.public_send(dir)
    else
      robot_dest = robot.public_send(dir)
      box_dest = robot_dest.public_send(dir)
      box_dest = box_dest.public_send(dir) while box_dest.box?

      next if box_dest.wall?

      box_dest.type = 'O'
      robot.type = '.'
      robot = robot_dest
    end
    robot.type = '@'
  end
  Node.all.values.select(&:box?).sum do |node|
    node.y * 100 + node.x
  end
end

def part2(input)
  robot = Node.all.values.find { _1.type == '@' }

  input.each_with_index do |dir, idx|
    next if robot.public_send(dir).wall?

    if robot.public_send(dir).free?
      robot.type = '.'
      robot = robot.public_send(dir)
    else
      dest = robot.public_send(dir)

      if dest.can_move?(dir)
        dest.move_box(dir, idx)
        robot.type = '.'
        robot = dest
        robot.type = '@'
      end
    end
    robot.type = '@'
  end

  Node.all.values.select { _1.type == '[' }.sum do |node|
    node.y * 100 + node.x
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input', big: true))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(2028, part1(parse('sample')))
  end

  def test_part1_sample2
    assert_equal(10_092, part1(parse('sample2')))
  end

  def test_part2
    assert_equal(9021, part2(parse('sample2', big: true)))
  end
end
