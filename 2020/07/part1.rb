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

set = Set.new(['shiny gold bag'])
old_set = Set.new
while (set != old_set)
  old_set = set.dup
  CONTAIN.each do |k, arr|
    set.dup.each do |f|
      set << k if arr.any? { |v| v.include?(f) }
    end
  end
end

p set.length - 1
