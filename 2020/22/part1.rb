#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.split("\n\n")
cards = input.map do |i|
  _, *cards = i.split("\n")
  cards.map(&:to_i)
end

while cards.none?(&:empty?)
  c1 = cards.first.shift
  c2 = cards.last.shift
  if c1 > c2
    cards.first.push c1, c2
  else
    cards.last.push c2, c1
  end
end

result = cards.flatten.reverse.each_with_index.sum do |n, idx|
  n * (idx + 1)
end

p result
