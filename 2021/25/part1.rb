#! /usr/bin/env ruby
# frozen_string_literal: true

INPUT = ARGF.each_line.to_a.freeze
X_SIZE = INPUT.first.chop.chars.length
Y_SIZE = INPUT.length

state = INPUT.each_with_index.each_with_object({}) do |(row, y), hash|
  row.chop.chars.each_with_index do |char, x|
    hash[[y, x]] = char if %w[v >].include?(char)
  end
end

def move(state, char, dx, dy)
  to_compare = state.sort.to_h
  to_compare.each do |(y, x), c|
    next unless c == char

    to_move = [(y + dy) % Y_SIZE, (x + dx) % X_SIZE]
    unless to_compare.key?(to_move)
      state[to_move] = char
      state.delete([y, x])
    end
  end
end

i = 0
prev_state = nil
while prev_state != state
  i += 1
  prev_state = state.dup
  move(state, '>', 1, 0)
  move(state, 'v', 0, 1)
end

puts i
