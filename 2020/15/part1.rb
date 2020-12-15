#! /usr/bin/env ruby
# frozen_string_literal: true

turns = ARGF.lines.map(&:strip).first.split(',').map(&:to_i)

2020.times do
  count = turns.count { |v| v == turns.last }
  if count == 1
    turns.push 0
  elsif count > 1
    turns.push(
      turns.each_index.select { |idx| turns[idx] == turns.last }.last(2).reverse.inject(:-)
    )
  end
end

p turns[2019]
