#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(file)
  file.lines.map do |line|
    map, layout = line.split
    [map, layout.split(',').map(&:to_i)]
  end
end

class Branch
  attr_reader :layout, :group, :current, :count, :length

  def initialize(layout:, group:, current:, count:, length:)
    @group = group
    @current = current
    @count = count
    @length = length
    @layout = layout
  end

  def combine(others)
    @count += others.sum(&:count)
    self
  end

  def dot
    if current == '#'
      if layout[group] == length
        # end the branch as we are at the right length
        @current = '.'
      else
        # discard the branch as it was not the correct length
        return nil
      end
    end
    self
  end

  def hash
    if current == '#'
      if layout[group] && layout[group] > length
        # extend the branch as it has not reached maximum length
        @length += 1
      else
        # discard the branch as it is now too long
        return nil
      end
    else 
      # advance to the next group
      @group += 1
      @length = 1
      @current = '#'
    end
    self
  end
end


def count(map, layout)
  branches = [
    Branch.new(layout: layout, group: -1, length: 0, current: '.', count: 1)
  ]
  map.chars.each_with_index do |chr, idx|
    branches =
      if chr == '.'
        branches.map { _1.dot }
      elsif chr == '#'
        branches.map { _1.hash }
      elsif chr == '?'
        branches.map { [_1.dup.dot, _1.dup.hash] }
      end.
        flatten.
        compact.
        group_by { [_1.group, _1.length, _1.current] }.
        values.
        map { _1[0].combine(_1[1..]) }
  end
  branches.sum do |branch|
    branch.length == layout.last && branch.group == layout.count - 1 ? branch.count : 0
  end
end

def part1(data)
  data.map { count(*_1) }
end

def part2(data)
  data.map do |map, layout|
    count(([map] * 5).join('?'), layout * 5)
  end
end

if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{part1(input).sum}"
  puts "Part 2: #{part2(input).sum}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal([1, 4, 1, 1, 4, 10], part1(parse(File.read('sample'))))
  end

  def test_part2
    assert_equal([1, 16384, 1, 16, 2500, 506250], part2(parse(File.read('sample'))))
  end
end
