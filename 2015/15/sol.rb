#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).map do |line|
    line.scan(/-?\d+/).map(&:to_i)
  end
end

def calc_score(rules, types, cal_count = nil)
  foo = types.each_with_index.each_with_object(Array.new(5) { 0 }) do |(qty, cookie), arr|
    rules[cookie].each_with_index do |val, idx|
      arr[idx] += qty * val
    end
  end

  return 0 if cal_count && foo.last != cal_count

  foo.first(4).map { it.clamp(0..) }.inject(:*)
end

def sol(input, cal_count)
  max = -1
  (0..100).each do |a|
    (0..100).each do |b|
      next if a + b > 100
      (0..100).each do |c|
        next if a + b + c > 100
        d = 100 - (a + b + c)
        score = calc_score(input, [a, b, c, d], cal_count)
        max = score if score > max
      end
    end
  end
  max
end

def part1(input) = sol(input, nil)
def part2(input) = sol(input, 500)

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end
