#! /usr/bin/env ruby
# frozen_string_literal: true

INPUT = ARGF.read.split("\n\n").map(&:each_line).freeze
REACTIONS = INPUT.last.map { _1.chop.split(' -> ') }.to_h.freeze
polymer = INPUT.first.first.chars

10.times do
  polymer = (
    polymer.each_cons(2).map do |a, b|
      if (match = REACTIONS[a + b])
        a + match
      else
        a
      end
    end + [polymer[-1]]
  ).join.chars
end
puts polymer.join.chars.tally.map(&:last).minmax.sort.reverse.inject(:-)
