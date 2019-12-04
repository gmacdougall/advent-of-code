#!/usr/bin/env ruby

require 'pry'
def only_two_group(num)
  num.to_s.chars.each_with_object(Hash.new(0)) do |n, count|
    count[n] += 1
  end.values.any? { |v| v == 2 }
end

result = (356261..846303).select do |num|
  nums = num.to_s.chars.map(&:to_i).each_cons(2)
  nums.any? { |a, b| a == b } &&
    nums.all? { |a, b| a <= b } &&
    only_two_group(num)
end

puts result.count
