#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

def parse(file)
  file.lines.map do |line|
    dir, num, code = line.strip.split(' ')
    [dir, num.to_i]
  end
end

def fill(arr, node)
  to_fill = [node]
  while to_fill.any?
    x, y = to_fill.pop
    arr[y][x] = '#'
    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dx, dy|
      to_fill.push([x + dx, y + dy]) if y + dy >= 0 && x + dx >= 0 && arr[y + dy] && arr[y + dy][x + dx] == '.'
    end
  end
end

def part1(data)
  x = 0
  y = 0
  locs = Set.new
  locs << [x, y]

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

    num.times do
      x += dx
      y += dy
      locs << [x, y]
    end
  end

  x_range = Range.new(*locs.map(&:first).minmax)
  y_range = Range.new(*locs.map(&:last).minmax)

  arr = y_range.map do |y|
    x_range.map do |x|
      locs.include?([x, y]) ? '#' : '.'
    end
  end

  _, y = arr.each_with_index.find { |a, b| a.join.match?(/^\.+#\.+#\.+$/) }
  y ||= 1
  x = arr[y].index { _1 == '#' } + 1

  fill(arr, [x, y])
  puts arr.map(&:join)
  arr.flatten.tally['#']
end

if File.exist?('input')
  data = parse(File.read('input'))
  puts "Part 1: #{part1(data)}"
  #puts "Part 2: #{Node.part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    data = parse(File.read('sample'))
    assert_equal(62, part1(data))
  end
end
