#!/usr/bin/env ruby

require 'prime'

NUMBER = 10_551_381

puts (1..NUMBER).select { |i| NUMBER % i == 0 }.sum
