#! /usr/bin/env ruby
# frozen_string_literal: true

input = gets.split(',').map(&:to_i)
result = Range.new(*input.minmax).map do |pos|
  input.sum { |n| (pos - n).abs }
end
puts result.min
