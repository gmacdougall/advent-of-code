#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip)

x = 0
y = 0
deg = 90

input.each do |line|
  instruction = line[0]
  num = line[1..-1].to_i

  case instruction
  when 'N'
    y += num
  when 'S'
    y -= num
  when 'E'
    x += num
  when 'W'
    x -= num
  when 'L'
    deg -= num
  when 'R'
    deg += num
  when 'F'
    rad = deg * Math::PI / 180
    x += Math.sin(rad).round * num
    y += Math.cos(rad).round * num
  end
end

puts x.abs + y.abs
