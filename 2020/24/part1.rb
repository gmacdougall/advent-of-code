#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip).map(&:chars)

tiles = Hash.new(false)

input.each do |line|
  x = 0
  y = 0

  while !line.empty?
    dir = line.shift
    dir += line.shift if dir == 'n' || dir == 's'

    case dir
    when 'ne'
      y += 1
      x += 0.5
    when 'nw'
      y += 1
      x -= 0.5
    when 'se'
      y -= 1
      x += 0.5
    when 'sw'
      y -= 1
      x -= 0.5
    when 'e'
      x += 1
    when 'w'
      x -= 1
    end
  end

  tiles[[x, y]] = !tiles[[x, y]]
end

p tiles.values.count { |v| v }
