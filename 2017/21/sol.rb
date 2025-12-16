#! /usr/bin/env ruby
# frozen_string_literal: true

def to_grid(str)
  str.split('/').map(&:chars)
end

def parse(fname)
  File.read(fname).lines(chomp: true).flat_map do |line|
    from, to = line.split(' => ').map { to_grid it }
    4.times.flat_map do
      from = from.transpose.map(&:reverse)
      [[from, to], [from.map(&:reverse), to]]
    end
  end.to_h
end

def run(input, times)
  pic = to_grid('.#./..#/###')
  times.times do
    size = pic.size
    new_pic = []

    div = (size % 2).zero? ? 2 : 3
    (size / div).times do |y_div|
      y_offset = div * y_div
      (size / div).times do |x_div|
        x_offset = div * x_div
        mini_grid = []
        (0...div).each do |y|
          mini_grid[y] = []
          (0...div).each do |x|
            mini_grid[y][x] = pic[y + y_offset][x + x_offset]
          end
        end

        new_mini_pic = input[mini_grid]
        new_mini_pic.each_with_index do |line, y|
          new_y_offset = y_div * new_mini_pic.size
          new_pic[y + new_y_offset] ||= []
          line.each_with_index do |c, x|
            new_x_offset = x_div * new_mini_pic.size
            new_pic[y + new_y_offset][x + new_x_offset] = c
          end
        end
      end

    end
    pic = new_pic
  end
  pic.flatten.tally['#']
end

if File.exist?('input')
  puts "Part 1: #{run(parse('input'), 5)}"
  puts "Part 2: #{run(parse('input'), 18)}"
end
