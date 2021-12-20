#! /usr/bin/env ruby
# frozen_string_literal: true

E_INPUT, IMAGE = ARGF.read.split("\n\n").map(&:each_line)
ENHANCEMENT = E_INPUT.first.chars.map { _1 == '#' ? 1 : 0 }.freeze

def run(times)
  output = Hash.new(0)
  IMAGE.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      output[[x, y]] = char == '#' ? 1 : 0
    end
  end

  range = Range.new(-(2 * times), IMAGE.to_a.length + (2 * times))

  times.times do |n|
    new_output = Hash.new(n.odd? && ENHANCEMENT[0] == 1 ? ENHANCEMENT[-1] : ENHANCEMENT[0])

    range.each do |y|
      range.each do |x|
        binary_string = (-1..1).flat_map do |dy|
          (-1..1).map { |dx| output[[x + dx, y + dy]] }
        end.join

        new_output[[x, y]] = ENHANCEMENT[binary_string.to_i(2)]
      end
    end

    output = new_output
  end

  output.values.count { |v| v == 1 }
end

puts "Part 1: #{run(2)}"
puts "Part 2: #{run(50)}"
