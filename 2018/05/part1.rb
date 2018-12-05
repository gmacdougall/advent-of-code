#!/usr/bin/env ruby

previous = nil
polymer = ARGF.read.strip
to_remove =  ('a'..'z').flat_map { |chr| [chr + chr.upcase, chr.upcase + chr] }

while (previous != polymer)
  previous = polymer.dup
  to_remove.each { |pattern| polymer.gsub!(pattern, '') }
end

puts polymer.length
