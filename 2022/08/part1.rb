#! /usr/bin/env ruby

input = ARGF.map { _1.strip.chars.map { |c| [c.to_i, false] } }
count = 0

[input, input.transpose].each do |test|
  test.each do |i|
    [i, i.reverse].each do |row|
      seen = []
      row.each do |col|
        value = col.first
        if seen.empty? || value > seen.max
          seen << value
          col[1] = true
        end
      end
    end
  end
end

p input.flatten(1).map(&:last).count { _1 }
