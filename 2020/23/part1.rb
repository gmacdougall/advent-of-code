#! /usr/bin/env ruby
# frozen_string_literal: true

arr = ARGF.read.strip.chars.map(&:to_i)

100.times do
  current, *pick_up = arr.shift(4)
  arr.push(current)
  destination = arr.index(arr.select { |n| n < current }.max || arr.max)
  arr = arr[0..destination] + pick_up + arr[(destination + 1)..]
end

arr.rotate! while arr.first != 1

puts arr[1..].join
