#! /usr/bin/env ruby
# frozen_string_literal: true

s = ARGF.read.split(',').map(&:to_i).tally
256.times do
  s.transform_keys!(&:pred)
  s[8] = s.delete(-1) { 0 }
  s[6] ||= 0
  s[6] += s[8]
end

puts s.values.sum
