#! /usr/bin/env ruby
# frozen_string_literal: true

INPUT = ARGF.read.split("\n\n").map(&:each_line).freeze
REACTIONS = INPUT.last.map { _1.chop.split(' -> ') }.to_h.freeze
POLYMER = INPUT.first.first.chars.freeze
FIRST_AND_LAST = [POLYMER.first, POLYMER.last].freeze

pairs = POLYMER.each_cons(2).map(&:join).tally
40.times do
  pairs = pairs.each_with_object(Hash.new(0)) do |(str, count), new_pairs|
    new_pairs[str[0] + REACTIONS[str]] += count
    new_pairs[REACTIONS[str] + str[1]] += count
  end
end

puts(
  REACTIONS.values.uniq.map do |char|
    pairs.sum do |key, val|
      key.chars.sum { |k_char| k_char == char ? val : 0 }
    end + (FIRST_AND_LAST.include?(char) ? 1 : 0)
  end.map { _1 / 2 }.minmax.reverse.inject(:-)
)
