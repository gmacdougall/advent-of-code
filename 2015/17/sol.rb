#! /usr/bin/env ruby
# frozen_string_literal: true

jars = File.read('input').lines.map(&:to_i)

def part1(jars)
  (1..jars.count).sum do |combo_count|
    jars.combination(combo_count).count do |arr|
      arr.sum == 150
    end
  end
end

def part2(jars)
  (1..jars.count).each do |combo_count|
    count = jars.combination(combo_count).count do |arr|
      arr.sum == 150
    end
    return count if count > 0
  end
end

puts "Part 1: #{part1(jars)}"
puts "Part 2: #{part2(jars)}"
