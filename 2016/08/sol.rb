#! /usr/bin/env ruby
# frozen_string_literal: true

class Screen
  def initialize(x, y)
    @pixels = y.times.map do
      Array.new(x) { false }
    end
  end

  def num_on = @pixels.flatten.count { it }

  def dump
    @pixels.each do |line|
      puts line.map { it ? '█' : ' ' }.join
    end
  end

  def rect(sx, sy)
    sy.times do |y|
      sx.times do |x|
        @pixels[y][x] = true
      end
    end
  end

  def rotate_column(x, by)
    foo = @pixels.transpose
    foo[x].rotate!(-by)
    @pixels = foo.transpose
  end

  def rotate_row(y, by)
    @pixels[y].rotate!(-by)
  end

  def rotate(type, val, by)
    case type
    when 'column'
      rotate_column(val, by)
    when 'row'
      rotate_row(val, by)
    else
      fail
    end
  end
end

def part1(input)
  screen = Screen.new(50, 6)
  input.each do |line|
    cmd, *rest = line.split
    case cmd
    when 'rect'
      screen.rect(*rest.join.scan(/\d+/).map(&:to_i))
    when 'rotate'
      screen.rotate(rest[0], *rest.join.scan(/\d+/).map(&:to_i))
    else
      fail
    end
  end
  screen.dump
  screen.num_on
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').lines)}"
  #puts "Part 2: #{part2('input')}"
end
