#! /usr/bin/env ruby
# frozen_string_literal: true

puts(
  ARGF
    .map(&:to_i)
    .each_cons(2)
    .count { |a, b| a < b }
)
