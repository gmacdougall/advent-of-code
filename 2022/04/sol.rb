#! /usr/bin/env ruby

input = ARGF.map { _1.split(',').map { |s| Range.new(*s.split('-').map(&:to_i)) } }
p input.count { |a, b| a.cover?(b) || b.cover?(a) }
p input.count { |a, b| a.cover?(b.first) || a.cover?(b.last) || b.cover?(a.first) || b.cover?(a.last) }


