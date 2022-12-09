#! /usr/bin/env ruby

require 'set'

input = ARGF.map(&:split).map { [_1, _2.to_i] }

knots = 10.times.map { [0, 0] }
tail_visited = Set.new

def move(head, tail)
  if (head[0] - tail[0]).abs > 1 || (head[1] - tail[1]).abs > 1
    tail[0] += 1 if (head[0] - tail[0]) > 0
    tail[0] -= 1 if (head[0] - tail[0]) < 0
    tail[1] += 1 if (head[1] - tail[1]) > 0
    tail[1] -= 1 if (head[1] - tail[1]) < 0
  end
end

input.each do |dir, len|
  dx = dy = 0
  case dir
  when "U"
    dy = -1
  when "D"
    dy = 1
  when "L"
    dx = -1
  when "R"
    dx = 1
  end

  len.times do
    knots[0][0] += dx
    knots[0][1] += dy

    knots.each_cons(2) { move(*_1) }

    tail_visited << knots.last.dup
  end
end

p tail_visited.size
