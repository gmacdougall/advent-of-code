#! /usr/bin/env ruby

INPUT = ARGF.map(&:split)

SCORE = {
  rock: 1,
  paper: 2,
  scissors: 3
}

MAP = {
  'A' => :rock,
  'B' => :paper,
  'C' => :scissors,
  'X' => :rock,
  'Y' => :paper,
  'Z' => :scissors,
}

BEATS = {
  rock: :scissors,
  scissors: :paper,
  paper: :rock,
}

part1 = INPUT.sum do |match|
  first = MAP[match.first]
  last = MAP[match.last]

  SCORE[last] + if first == last
    3
  elsif BEATS[last] == first
    6
  else
    0
  end
end

puts "Part 1: #{part1}"

LOSES = BEATS.invert

part2 = INPUT.sum do |match|
  first = MAP[match.first]
  last = match.last

  if last == 'X'
    0 + SCORE[BEATS[first]]
  elsif last == 'Y'
    3 + SCORE[first]
  else 
    6 + SCORE[LOSES[first]]
  end
end

puts "Part 2: #{part2}"
