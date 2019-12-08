#!/usr/bin/env ruby

layers = File.read('input').strip.chars.map(&:to_i).each_slice(25 * 6)
min_zeros = layers.min_by { |l| l.select(&:zero?) }
puts min_zeros.count { |n| n == 1 } * min_zeros.count { |n| n == 2 }
