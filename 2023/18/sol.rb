#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

class Rect
  attr_reader :x, :y, :size, :line
  attr_accessor :type

  def initialize(x, y, size, line)
    @x = x
    @y = y
    @size = size
    @line = line
    @type = line ? :line : nil

    @@all ||= {}
    @@all[y] ||= {}
    @@all[y][x] = self
  end

  def self.find(x, y)
    return unless @@all[y]
    @@all[y][x]
  end

  def self.clear
    @@all = {}
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

  def adjacent
    [up, down, right, left].compact
  end

  def self.fill
    to_search = []
    @@all.keys.minmax.each do |y|
      @@all.values.flat_map(&:keys).uniq.each do |x|
        r = find(x, y)
        unless r.type == :line
          r.type = :ground
          to_search << r
        end
      end
    end

    @@all.values.flat_map(&:keys).minmax.each do |x|
      @@all.keys.each do |y|
        r = find(x, y)
        unless r.type == :line
          r.type = :ground
          to_search << r
        end
      end
    end

    while to_search.any?
      curr = to_search.pop
      curr.adjacent.each do |r|
        if r.type.nil?
          r.type = :ground
          to_search << r
        end
      end
    end
    @@all.values.flat_map(&:values).select { _1.type != :ground }.sum(&:size)
  end
end

def go(data)
  x = 0
  y = 0
  lines = []

  data.each do |dir, num|
    dx = 0
    dy = 0
    case dir
    when 'R'
      dx = 1
    when 'L'
      dx = -1
    when 'U'
      dy = -1
    when 'D'
      dy = 1
    end

    from = [x, y]
    x += dx * num
    y += dy * num
    to = [x, y]
    lines << { from:, to: }
  end

  x_boxes = lines.map { _1[:from].first }.flat_map { [_1, _1 + 1] }.uniq.sort.each_cons(2).map { |a, b| a...b }
  y_boxes = lines.map { _1[:from].last }.flat_map { [_1, _1 + 1] }.uniq.sort.each_cons(2).map { |a, b| a...b }
  x_boxes.each_with_index do |xbox, xi|
    y_boxes.each_with_index do |ybox, yi|
      part_of_line = false
      if xbox.count == 1 && lines.find { |line| line[:from][0] == xbox.first && line[:to][0] == xbox.first && Range.new(*[line[:from][1], line[:to][1]].sort).cover?(ybox) } ||
        ybox.count == 1 && lines.find { |line| line[:from][1] == ybox.first && line[:to][1] == ybox.first && Range.new(*[line[:from][0], line[:to][0]].sort).cover?(xbox) }
        part_of_line = true
      end
      Rect.new(xi, yi, xbox.count * ybox.count, part_of_line)
    end
  end

  Rect.fill
end

def part1(file)
  go(
    file.lines.map do |line|
      dir, num, code = line.strip.split(' ')
      [dir, num.to_i]
    end
  )
end

def part2(file)
  go(
    file.lines.map do |line|
      hex, d = line.match(/#(\w{5})(\w)/).captures
      dir = case d
      when '0'
        'R'
      when '1'
        'D'
      when '2'
        'L'
      when '3'
        'U'
      end
      [dir, hex.to_i(16)]
    end
  )
end

if File.exist?('input')
  input = File.read('input')
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2(input)}"
  Rect.clear
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(62, part1(File.read('sample')))
    Rect.clear
  end

  def test_part2
    assert_equal(952_408_144_115, part2(File.read('sample')))
    Rect.clear
  end
end
