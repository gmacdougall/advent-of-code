#! /usr/bin/env ruby
# frozen_string_literal: true

x = y = aim = 0
ARGF.each_line do |line|
  action, num = line.split(' ')
  num = num.to_i

  case action
  when 'forward'
    x += num
    y += aim * num
  when 'down'
    aim += num
  when 'up'
    aim -= num
  end
end

puts x * y
