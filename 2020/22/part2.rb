#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

input = ARGF.read.split("\n\n")
cards = input.map do |i|
  _, *cards = i.split("\n")
  cards.map(&:to_i)
end

def combat(game, p1, p2)
  # puts "=== Game #{game} ===\n\n"
  states = Set.new
  round = 1
  while p1.any? && p2.any?
    hash = [p1, p2].hash
    if states.include?(hash)
      return true
    end
    states << hash

    # puts "-- Round #{round} (Game #{game}) --\n\n"
    # puts "Player 1's deck: #{p1.join(', ')}"
    # puts "Player 2's deck: #{p2.join(', ')}"

    c1 = p1.shift
    c2 = p2.shift

    # puts "Player 1 plays: #{c1}"
    # puts "Player 2 plays: #{c2}"

    p1_winner = if c1 <= p1.length && c2 <= p2.length
                  # puts "Playing a sub-game to determine the winner...\n\n"
                  combat(game + 1, p1.first(c1), p2.first(c2))
                else
                  c1 > c2
                end
    if p1_winner
      # puts "Player 1 wins round #{round} of game #{game}!\n"
      p1.push c1, c2
    else
      # puts "Player 2 wins round #{round} of game #{game}!\n"
      p2.push c2, c1
    end
    # puts ''
    round += 1
  end

  p1.any?
end

combat(1, *cards)

result = cards.flatten.reverse.each_with_index.sum do |n, idx|
  n * (idx + 1)
end

p result
