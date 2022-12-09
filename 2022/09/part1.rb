#! /usr/bin/env ruby

require 'set'

input = ARGF.map(&:split).map { [_1, _2.to_i] }

head = [0, 0]
tail = head.dup

tail_visited = Set.new

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
    puts "Head: #{head.inspect}, Tail: #{tail.inspect}"
    head[0] += dx
    head[1] += dy

    if (head[0] - tail[0]).abs > 1 || (head[1] - tail[1]).abs > 1
      tail[0] += 1 if (head[0] - tail[0]) > 0
      tail[0] -= 1 if (head[0] - tail[0]) < 0
      tail[1] += 1 if (head[1] - tail[1]) > 0
      tail[1] -= 1 if (head[1] - tail[1]) < 0
    end

    tail_visited << tail.dup
  end
end

p tail_visited.size
