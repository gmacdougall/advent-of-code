#!/usr/bin/env ruby

require 'set'

input = ARGF.lines.map(&:strip)

CONTAIN = Hash[input.map do |line|
  line.gsub!('.', '')
  line.gsub!('bags', 'bag')
  line.split(' contain ').tap do |a|
    a[1] = a[1].split(', ')
    a[1] = [] if a[1] == ['no other bag']
  end
end].freeze

history = []
bags = [[1, 'shiny gold bag']]
while bags.any?
  history += bags
  bags = bags.flat_map do |count, bag|
    CONTAIN[bag].map do |a|
      num, *words = a.split(' ')
      [num.to_i * count, words.join(' ')]
    end
  end
end

p history.sum(&:first) - 1
