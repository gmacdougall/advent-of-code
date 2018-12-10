#!/usr/bin/env ruby

players, rounds = ARGV.map(&:to_i)

class Marble
  attr_accessor :prev
  attr_accessor :next
  attr_reader :n

  def initialize(n)
    @n = n
  end
end

current = Marble.new(0)
current.prev = current
current.next = current

scores = Array.new(players, 0)

(1..rounds).each do |round|
  if (round % 23).zero?
    7.times { current = current.prev }

    scores[round % players] += round
    scores[round % players] += current.n

    left = current.prev
    right = current.next
    left.next = right
    right.prev = left
    current = right
  else
    current = current.next
    left = current
    right = current.next
    current = Marble.new(round)
    current.prev = left
    left.next = current
    current.next = right
    right.prev = current
  end
end


puts scores.max
