#! /usr/bin/env ruby

input = ARGF.map { _1.strip.chars.map(&:to_i) }

totals = input.each_with_index.flat_map do |row, y|
  row.each_with_index.map do |val, x|
    multiply = [0] * 4

    [[1, 0], [0, 1], [-1, 0], [0, -1]].each_with_index do |(dx, dy), idx|
      (1..).each do |d|
        new_x = x + (d * dx)
        new_y = y + (d * dy)

        break if new_x < 0 || new_y < 0 || !input[new_y]

        test = input[new_y][new_x]

        if test
          multiply[idx] += 1
          break if test >= val
        else
          break
        end
      end
    end
    multiply.inject(:*)
  end
end

puts totals.max
