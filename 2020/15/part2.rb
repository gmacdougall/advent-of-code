#! /usr/bin/env ruby
# frozen_string_literal: true

turns = ARGF.lines.map(&:strip).first.split(',').map(&:to_i)

occurances = turns.each_with_index.to_h.transform_values { |n| [n] }

LENGTH = 30_000_000
last = turns.last

(turns.length...LENGTH).each do |i|
  if occurances[last].nil? || occurances[last].length == 1
    last = 0
  else
    last = occurances[last].last(2).reverse.inject(:-)
  end
  occurances[last] ||= []
  occurances[last].push(i)
end

p last
