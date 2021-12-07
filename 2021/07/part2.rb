#! /usr/bin/env ruby
# frozen_string_literal: true

input = gets.split(',').map(&:to_i)
result = Range.new(*input.minmax).map do |pos|
  input.sum do |y|
    n = (pos - y).abs
    n * (n + 1) / 2
  end
end
puts result.min
