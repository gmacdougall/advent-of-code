#!/usr/bin/env ruby

def frequency(str)
  str.chars.group_by(&:itself).transform_values!(&:size).values
end

frequencies = ARGF.map { |id| frequency(id) }

puts frequencies.select { |f| f.include?(2) }.count *
  frequencies.select { |f| f.include?(3) }.count
