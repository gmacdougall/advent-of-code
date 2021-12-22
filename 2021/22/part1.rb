#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

INPUT = ARGF.map { [_1.split.first, _1.scan(/-?\d+/).map(&:to_i).each_slice(2).map(&:sort).map { |a, b| a..b }] }.freeze

zone = Set.new
INPUT.each do |i|
  i.last[0].each do |x|
    next unless (-50..50).cover?(x)

    i.last[1].each do |y|
      next unless (-50..50).cover?(y)

      i.last[2].each do |z|
        next unless (-50..50).cover?(z)

        if i.first == 'on'
          zone << [x, y, z]
        else
          zone.delete [x, y, z]
        end
      end
    end
  end
end

puts zone.length
