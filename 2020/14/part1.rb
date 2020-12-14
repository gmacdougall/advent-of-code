#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip)

memory = []
current_mask = nil

input.each do |line|
  if line.start_with?('mask = ')
    current_mask = line.gsub('mask = ', '')
  else
    addr, val = line.match(/mem\[(\d+)\] = (\d+)/).captures.map(&:to_i)
    bin = val.to_s(2).rjust(current_mask.length, '0')
    bin.chars.length.times do |n|
      bin[n] = current_mask[n] if current_mask[n] != 'X'
    end
    memory[addr] = bin.to_i(2)
  end
end

p memory.compact.sum
