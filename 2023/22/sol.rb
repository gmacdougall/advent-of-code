#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'minitest/autorun'

class Brick
  attr_reader :x, :y, :z
  attr_accessor :name

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z

    @@all_bricks ||= []
    @@all_bricks << self
    @@all ||= {}
    x.each do |px|
      @@all[px] ||= {}
      y.each do |py|
        @@all[px][py] ||= []
        @@all[px][py] << self
      end
    end
  end

  def self.all_bricks
    @@all_bricks
  end

  def self.clear
    @@all = {}
    @@all_bricks = []
  end

  def supports(exclude = [])
    return [:ground] if @z.min == 1
    @x.flat_map do |x|
      @y.flat_map do |y|
        @@all[x][y].select { !exclude.include?(_1) && _1.z.cover?(@z.min - 1) }
      end
    end
  end

  def drop
    return 0 if z.min == 1
    share_column = @x.flat_map do |x|
      @y.flat_map { |y| @@all[x][y].reject { _1 == self } }
    end
    new_z = share_column.map(&:z).flat_map(&:to_a).select { _1 < z.min }.max || 0
    return 0 if (new_z + 1) == z.min
    @z = (new_z + 1)..(new_z + z.size)
    1
  end

  def self.setup
    loop do
      changed = all_bricks.sum(&:drop)
      puts changed
      break if changed == 0
    end
  end

  def self.part1
    all_bricks.reject do |to_exclude|
      exclude = [to_exclude]
      all_bricks.any? do |to_test|
        to_test.supports(exclude).empty?
      end
    end.count
  end

  def self.part2
    all_bricks.each_with_index.sum do |to_exclude, idx|
      exclude = [to_exclude].to_set
      loop_again = true
      while loop_again
        loop_again = false
        all_bricks.each do |to_test|
          next if exclude.include?(to_test)
          if to_test.supports(exclude).empty?
            loop_again = true
            exclude << to_test
          end
        end
      end
      exclude.count - 1
    end
  end
end

def parse(file)
  file.lines.each_with_index do |line, idx|
    points = line.strip.split('~').map { |d| d.split(',').map(&:to_i) }.transpose.map { Range.new(*_1) }
    Brick.new(*points)#.name = (65 + idx).chr
  end
  Brick.setup
end

if File.exist?('input')
  parse(File.read('input'))
  puts "Part 1: #{Brick.part1}"
  puts "Part 2: #{Brick.part2}"
end

class MyTest < Minitest::Test
  def setup
    Brick.clear
    parse(File.read('sample'))
  end

  def test_part1
    assert_equal(5, Brick.part1)
  end

  def test_part2
    assert_equal(7, Brick.part2)
  end
end

