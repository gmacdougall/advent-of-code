#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative 'snailfish'

INPUT = ARGF.map { |line| SnailfishNumber.parse(line.chop) }
puts INPUT.inject(:+).magnitude
