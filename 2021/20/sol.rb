#! /usr/bin/env ruby
# frozen_string_literal: true

E_INPUT, IMAGE = ARGF.read.split("\n\n").map(&:each_line)
ENHANCEMENT = E_INPUT.first.chars.map { _1 == '#' ? 1 : 0 }.freeze
ENH_AREA = (-1..1)

def run(times)
  output = Hash.new(0)
  IMAGE.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      output[(x * 1000) + y] = char == '#' ? 1 : 0
    end
  end

  range = Range.new(-(2 * times), IMAGE.to_a.length + (2 * times))

  times.times do |n|
    new_output = Hash.new(n.odd? && ENHANCEMENT[0] == 1 ? ENHANCEMENT[-1] : ENHANCEMENT[0])

    range.each do |y|
      range.each do |x|
        idx = 0
        ENH_AREA.each do |dy|
          ENH_AREA.each do |dx|
            idx += output[((x + dx) * 1000) + y + dy]
            idx <<= 1
          end
        end
        idx >>= 1

        new_output[(x * 1000) + y] = ENHANCEMENT[idx]
      end
    end

    output = new_output
  end

  output.values.count { |v| v == 1 }
end

puts "Part 1: #{run(2)}"
puts "Part 2: #{run(50)}"
