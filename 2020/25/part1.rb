#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:to_i)

def loop_size(input, subject_number)
  value = 1

  result = 1
  loop do
    value = (value * subject_number) % 20201227
    break if input == value
    result += 1
  end
  result
end

def transform(loops, subject_number)
  value = 1
  loops.times do
    value = (value * subject_number) % 20201227
  end
  value
end

a = loop_size(input.first, 7)
b = loop_size(input.last, 7)

p transform(a, input.last)
p transform(b, input.first)
