#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip).to_a

START = input.first.to_i
bus_ids = input.last.split(',').reject { |s| s == 'x' }.map(&:to_i)

time = START
loop do
  if bus_ids.any? { |id| (time % id).zero? }
    p((time - START) * bus_ids.find { |id| (time % id).zero? })
    exit
  end
  time += 1
end
