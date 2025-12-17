#! /usr/bin/env ruby
# frozen_string_literal: true

require 'prime'

b = 57
b = b * 100 + 100000
c = b + 17000

puts((b..c).step(17).count { |n| !n.prime? })
