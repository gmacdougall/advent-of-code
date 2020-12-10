#!/usr/bin/env ruby
# frozen_string_literal: true

input = (ARGF.lines.map(&:strip).map(&:to_i) + [0]).sort

p(
  input.each_cons(2).select { |a, b| b - a == 1 }.length *
  (input.each_cons(2).select { |a, b| b - a == 3 }.length + 1)
)
