#! /usr/bin/env ruby
# frozen_string_literal: true

gamma = ARGF
  .map { |line| line.strip.chars }
  .transpose
  .map { |a| a.tally.max_by(&:last).first }
epsilon = gamma.map { |c| c == '0' ? 1 : 0 }

puts gamma.join.to_i(2) * epsilon.join.to_i(2)
