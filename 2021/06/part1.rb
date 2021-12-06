#! /usr/bin/env ruby
# frozen_string_literal: true

state = ARGF.read.split(',').map(&:to_i)

80.times do
  to_append = 0
  state = state.map do |n|
    if n.zero?
      to_append += 1
      6
    else
      n - 1
    end
  end
  state += Array.new(to_append, 8)
end

puts state.count
