#!/usr/bin/env ruby

players, rounds = ARGV.map(&:to_i)

circle = [0]
position = 0

scores = Array.new(players, 0)

(1..rounds).each do |round|
  if (round % 23).zero?
    position = (position - 7) % circle.length

    scores[round % players] += round
    scores[round % players] += circle[position]

    circle.delete(circle[position])
  else
    position = (position + 2) % circle.length

    if position == 0
      circle << round
      position = circle.length - 1
    else
      left = circle.slice(0...position)
      right = circle.slice(position..-1) || []
      circle = left + [round] + right
    end
  end
end


puts scores.max
