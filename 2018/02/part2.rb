#!/usr/bin/env ruby

ids = ARGF.map(&:chars)

ids.each do |id1|
  ids.each do |id2|
    next if id1.eql?(id2)
    differences = 0
    result = ""

    id1.each_with_index do |char1, index|
      if id2[index] == char1
        result += char1
      else
        differences += 1
      end
    end

    puts result if differences == 1
  end
end
