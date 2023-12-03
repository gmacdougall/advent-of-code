#! /usr/bin/env ruby
# frozen_string_literal: true

class Schematic
  def initialize(str)
    @numbers = {}
    @symbols = {}

    str.lines.map(&:strip).each_with_index do |line, y|
      start = 0
      line.chars.each_with_index do |char, x|
        if char.match?(/\d/)
          start = x unless start
        elsif start
          if x != 0
            range = start..(x - 1)
            @numbers[[range, y]] = line[range].to_i
          end
          start = nil
        end

        @symbols[[x, y]] = char if char.match?(/[^\d|\.]/)
      end

      if (start)
        range = start..(line.length - 1)
        @numbers[[range, y]] = line[range].to_i
      end
    end
  end

  def part1
    @numbers.sum do |(num_x_range, num_y), num|
      search_x = (num_x_range.min - 1)..(num_x_range.max + 1)
      search_y = (num_y - 1)..(num_y + 1)

      adjacent_symbol = search_x.any? do |x|
        search_y.any? do |y|
          @symbols.has_key?([x, y])
        end
      end

      adjacent_symbol ? num : 0
    end
  end

  def part2
    @symbols.select { _2 == '*' }.sum do |(sx, sy), _|
      found = Set.new
      ((sx - 1)..(sx + 1)).each do |x|
        ((sy - 1)..(sy + 1)).each do |y|
          num = @numbers.find { |(nx, ny), _| nx.cover?(x) && ny == y }
          found << num if num
        end
      end

      found.length == 2 ? found.map(&:last).inject(1, :*) : 0
    end
  end
end

if File.exist?('input')
  input = Schematic.new(File.read('input'))
  puts "Part 1: #{input.part1}"
  puts "Part 2: #{input.part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    Schematic.new(File.read('sample'))
  end

  def test_part1
    assert_equal(4361, sample.part1)
  end

  def test_part2
    assert_equal(467835, sample.part2)
  end
end
