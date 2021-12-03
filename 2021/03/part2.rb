#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.map { |line| line.strip.chars.map(&:to_i) }

def search(arr)
  idx = 0
  while arr.length > 1
    tally = arr.transpose[idx].tally
    to_select = yield(tally) ? 1 : 0
    arr.select! { |a| a[idx] == to_select }
    idx += 1
  end
  arr.join.to_i(2)
end

oxygen = search(input.dup) { |tally| tally[1] >= tally[0] }
co2 = search(input.dup) { |tally| tally[0] > tally[1] }
puts oxygen * co2
