#! /usr/bin/env ruby

cycle = 0
x = 1
signal_strengths = []

input = ARGF.map(&:strip).map(&:split).each do |command, val|
  case command
  when 'noop'
    cycle += 1
    signal_strengths << cycle * x if cycle % 40 == 20
  when 'addx'
    cycle += 1
    signal_strengths << cycle * x if cycle % 40 == 20
    cycle += 1
    signal_strengths << cycle * x if cycle % 40 == 20
    x += val.to_i
  end
end

puts signal_strengths.sum
