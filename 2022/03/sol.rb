#! /usr/bin/env ruby

input = ARGF.each_line.map { _1.strip.chars }

parts = [
  input.map { _1.each_slice(_1.length / 2).to_a }.map { _1 & _2 },
  input.each_slice(3).map { _1 & _2 & _3 },
].each do |part|
  puts(
    part.sum do |chars|
      chars.sum do |c|
        case c
        when 'a'..'z'
          c.ord - 96
        else
          c.ord - 38
        end
      end
    end
  )
end
