#!/usr/bin/env ruby

prereqs = {}

('A'..'Z').each do |letter|
  prereqs[letter] = []
end

ARGF.each do |line|
  parts = line.split(' ')

  prereqs[parts[7]] <<  parts[1]
end

complete = []

prereqs.count.times do
  found = prereqs.select { |key, values| values.reject { |val| complete.include?(val) }.empty? }.keys.sort.first
  prereqs.delete(found)
  complete << found
end

puts complete.join
