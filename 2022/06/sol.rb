#! /usr/bin/env ruby

orig = ARGF.read.chars
puts orig.each_cons(4).each_with_index.find { |c,idx| c.uniq.length == 4 }.last + 4
puts orig.each_cons(14).each_with_index.find { |c,idx| c.uniq.length == 14 }.last + 14
