#!/usr/bin/env ruby

polymer = ARGF.read.strip

def react(polymer)
  previous = nil
  to_remove =  ('a'..'z').flat_map { |chr| [chr + chr.upcase, chr.upcase + chr] }

  while (previous != polymer)
    previous = polymer.dup
    to_remove.each { |pattern| polymer.gsub!(pattern, '') }
  end

  polymer
end

results = ('a'..'z').map do |letter|
  react(polymer.gsub(/[#{letter}#{letter.upcase}]/, '')).length
end

puts results.min
