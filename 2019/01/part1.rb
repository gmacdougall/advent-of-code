#!/usr/bin/env ruby

puts ARGF.sum { |arg| (arg.to_i / 3) - 2 }
