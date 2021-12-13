#! /usr/bin/env ruby
# frozen_string_literal: true

INPUT = ARGF.read.split("\n\n").map(&:each_line).freeze
FOLDS = INPUT.last.map do |fold|
  direction, num = fold.split('=')
  [direction[-1] == 'x' ? 0 : 1, num.to_i]
end.freeze
points = INPUT.first.map { _1.split(',').map(&:to_i) }

FOLDS.first.tap do |axis, val|
  points.map! do |pair|
    pair.each_with_index.map do |p, idx|
      p > val && axis == idx ? p - (2 * (p - val)) : p
    end
  end.uniq!
end
puts points.length
