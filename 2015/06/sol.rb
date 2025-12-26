#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines.map do |line|
    words = line.split
    op = (
      if words[0] == 'toggle'
        :toggle
      elsif words[1] == 'on'
        :on
      elsif words[1] == 'off'
        :off
      else
        fail
      end
    )
    [op, *line.scan(/\d+/).map(&:to_i)]
  end
end

def part1(input)
  grid = (0..999).map do |y|
    Array.new(1000) { false }
  end
  input.each do |todo, x1, y1, x2, y2|
    Range.new(*[y1, y2].sort).each do |y|
      Range.new(*[x1, x2].sort).each do |x|
        val = if todo == :toggle
          !grid[y][x]
        elsif todo == :on
          true
        else
          false
        end
        grid[y][x] = val
      end
    end
  end
  grid.flatten.count { it }
end

def part2(input)
  grid = (0..999).map do |y|
    Array.new(1000) { 0 }
  end
  input.each do |todo, x1, y1, x2, y2|
    Range.new(*[y1, y2].sort).each do |y|
      Range.new(*[x1, x2].sort).each do |x|
        if todo == :toggle
          grid[y][x] += 2
        elsif todo == :on
          grid[y][x] += 1
        else
          grid[y][x] -= 1
          grid[y][x] = 0 if grid[y][x].negative?
        end
      end
    end
  end
  grid.flatten.sum
end

puts "Part 1: #{part1(parse('input'))}"
puts "Part 2: #{part2(parse('input'))}"
