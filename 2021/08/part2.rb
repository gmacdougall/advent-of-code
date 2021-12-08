#! /usr/bin/env ruby
# frozen_string_literal: true

SEVEN_SEGMENT = {
  0 => %i[a b c e f g],
  1 => %i[c f],
  2 => %i[a c d e g],
  3 => %i[a c d f g],
  4 => %i[b c d f],
  5 => %i[a b d f g],
  6 => %i[a b d e f g],
  7 => %i[a c f],
  8 => %i[a b c d e f g],
  9 => %i[a b c d f g],
}.invert.freeze

result = ARGF.each_line.sum do |line|
  input, output = line.split('|').map(&:split)
  tally = input.join.chars.tally
  map = {
    b: tally.key(6),
    e: tally.key(4),
    f: tally.key(9),
  }
  map[:c] = (input.find { |s| s.length == 2 }.chars - map.fetch_values(:f)).first
  map[:a] = (input.find { |s| s.length == 3 }.chars - map.fetch_values(:c, :f)).first
  map[:d] = (input.find { |s| s.length == 4 }.chars - map.fetch_values(:b, :c, :f)).first
  map[:g] = (('a'..'g').to_a - map.values).first

  output.map do |digit|
    SEVEN_SEGMENT.fetch(map.invert.fetch_values(*digit.chars).sort)
  end.join.to_i
end
puts result
