#!/usr/bin/env ruby

input = ARGF.read.lines.map(&:strip)

taken = input.map do |line|
  front = 0
  back = 127
  left = 0
  right = 7

  line.chars.each do |c|
    case c
    when 'F'
      back = ((back - front) / 2) + front
    when 'B'
      front = ((back - front) / 2) + front + 1
    when 'L'
      right = ((right - left) / 2) + left
    when 'R'
      left = ((right - left) / 2) + left + 1
    end
  end

  front * 8 + left
end

puts(
  Range.new(*taken.minmax).find do |attempt|
    !taken.include?(attempt) && taken.include?(attempt - 1) && taken.include?(attempt + 1)
  end
)
