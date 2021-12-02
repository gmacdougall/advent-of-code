#! /usr/bin/env ruby
# frozen_string_literal: true

x = y = 0
ARGF.each_line do |line|
  action, num = line.split(' ')
  num = num.to_i

  case action
  when 'forward'
    x += num
  when 'down'
    y += num
  when 'up'
    y -= num
  end
end

puts x * y
