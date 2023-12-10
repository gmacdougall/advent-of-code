#! /usr/bin/env ruby
# frozen_string_literal: true

class Node
  attr_reader :x, :y
  attr_accessor :distance, :type

  def initialize(type, x, y)
    @type = type
    @x = x * 2
    @y = y * 2

    @@all ||= {}
    @@all[@y] ||= {}
    @@all[@y][@x] = self
  end

  def self.part2
    all_nodes = @@all.values.map(&:values).flatten
    result = Range.new(*all_nodes.map(&:y).minmax).map do |y|
      Range.new(*all_nodes.map(&:x).minmax).map do |x|
        node = find(x, y)
        left = find(x - 1, y)
        right = find(x + 1, y)
        up = find(x, y - 1)
        down = find(x, y + 1)

        if node&.dump
          node.dump
        elsif (y % 2) == 0 && left && right && left.restrictive_adjacent.include?(right)
          '═'
        elsif (y % 1) == 0 && up && down && up.restrictive_adjacent.include?(down)
          '║'
        else
          ' '
        end
      end
    end
    result = result.map { ['O', *_1, 'O'] }
    outside_row = Array.new(result.first.count) { 'O' }
    result = [outside_row, *result, outside_row]

    loop do
      new_result = result.map(&:dup)
      result.each_with_index do |y_lines, y|
        y_lines.each_with_index do |chr, x|
          if chr == 'O'
            [[x, y + 1], [x, y - 1], [x + 1, y], [x - 1, y]].each do |nx, ny|
              if new_result[ny] && new_result[ny][nx]
                new_result[ny][nx] = 'O' if result[ny][nx] == ' ' || result[ny][nx] == '.'
              end
            end
          end
        end
      end
      if ENV['DEBUG']
        puts
        result.each { puts _1.join }
        puts
        sleep 0.5
      end
      break if new_result.flatten == result.flatten
      result = new_result
    end
    result.flatten.count { _1 == '.' }
  end

  def self.flag_useless
    @@all.values.map(&:values).flatten.each do |node|
      node.type = '.' unless node.distance
    end
  end

  def self.all_by_type(type)
    all_nodes = @@all.values.map(&:values).flatten.select { _1.type == type }
  end

  def self.clear
    @@all = {}
  end

  def self.find(x, y)
    return nil if x < 0 || y < 0 || !@@all[y]
    @@all[y][x]
  end

  def dump
    case type
    when 'S'
      '╬'
    when '-'
      '═'
    when '|'
      '║'
    when 'L'
      '╚'
    when 'J'
      '╝'
    when '7'
      '╗'
    when 'F'
      '╔'
    when '.'
      '.'
    end
  end

  def north
    self.class.find(x, y - 2)
  end

  def south
    self.class.find(x, y + 2)
  end

  def west
    self.class.find(x - 2, y)
  end

  def east
    self.class.find(x + 2, y)
  end

  def restrictive_adjacent
    adjacent.select { |new| new.adjacent.include?(self) }
  end

  def adjacent
    case type
    when '|'
      [north, south]
    when '-'
      [east, west]
    when 'L'
      [north, east]
    when 'J'
      [north, west]
    when '7'
      [south, west]
    when 'F'
      [south, east]
    when 'S'
      [north, south, west, east]
    else
      []
    end.compact
  end
end

def parse(file)
  file.lines.each_with_index do |line, y|
    line.strip.chars.each_with_index do |type, x|
      Node.new(type, x, y)
    end
  end
end

def part1
  steps = 0
  to_search = Node.all_by_type('S')
  to_search.each { _1.distance = 0 }
  loop do
    next_to_search = []
    to_search.each do |node|
      if node.restrictive_adjacent.all?(&:distance)
        return [node, node.restrictive_adjacent].flatten.map(&:distance).max
      end
      node.restrictive_adjacent.each do |adj|
        unless adj.distance
          adj.distance = node.distance + 1
          next_to_search << adj
        end
      end
    end
    steps += 1
    to_search = next_to_search
  end
end

def part2
  part1
  Node.flag_useless
  Node.part2
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
  Node.clear
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    parse(File.read('sample'))
    assert_equal(8, part1)
    Node.clear
  end

  def test_part2_sample2
    parse(File.read('sample2'))
    assert_equal(4, part2)
    Node.clear
  end

  def test_part2_sample3
    parse(File.read('sample3'))
    assert_equal(4, part2)
    Node.clear
  end

  def test_part2_sample4
    parse(File.read('sample4'))
    assert_equal(8, part2)
    Node.clear
  end

  def test_part2_sample5
    parse(File.read('sample5'))
    assert_equal(10, part2)
    Node.clear
  end
end
