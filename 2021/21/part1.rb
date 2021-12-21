#! /usr/bin/env ruby
# frozen_string_literal: true

space = ARGF.map { _1.split.last.to_i }

die_rolls = (1..).lazy
scores = [0, 0]
current = 0

while scores.all? { _1 < 1000 }
  3.times { space[current] += die_rolls.next }
  space[current] = ((space[current] - 1) % 10) + 1
  scores[current] += space[current]
  current = current.zero? ? 1 : 0
end

puts (die_rolls.peek - 1) * scores.min
