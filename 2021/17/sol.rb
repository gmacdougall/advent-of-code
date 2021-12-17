#! /usr/bin/env ruby
# frozen_string_literal: true

x1, x2, y1, y2 = ARGF.read.scan(/(-?\d+)/).flatten.map(&:to_i)

X_RANGE = Range.new(*[x1, x2].sort)
Y_RANGE = Range.new(*[y1, y2].sort)

def test(x_vel, y_vel)
  history = [[0, 0]]
  loop do
    pos = [history.last[0] + x_vel, history.last[1] + y_vel]
    history << pos

    return history.map(&:last).max if
      X_RANGE.cover?(pos[0]) &&
      Y_RANGE.cover?(pos[1])

    break if pos[0] > X_RANGE.end || pos[1] < Y_RANGE.begin

    x_vel -= x_vel / x_vel.abs unless x_vel.zero?
    y_vel -= 1
  end
end

result = (1..X_RANGE.end).flat_map do |x|
  (Y_RANGE.begin..200).flat_map { |y| test(x, y) }
end

puts "Part 1: #{result.compact.max}"
puts "Part 2: #{result.compact.count}"
