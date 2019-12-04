#!/usr/bin/env ruby

result = (356261..846303).select do |num|
  nums = num.to_s.chars.map(&:to_i).each_cons(2)
  nums.any? { |a, b| a == b } && nums.all? { |a, b| a <= b }
end

puts result.count
