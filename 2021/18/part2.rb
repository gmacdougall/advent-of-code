#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative 'snailfish'

INPUT = ARGF.map { |line| SnailfishNumber.parse(line.chop) }
puts(INPUT.permutation(2).map { |a, b| (a + b).magnitude }.max)
