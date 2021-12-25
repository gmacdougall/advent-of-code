#! /usr/bin/env ruby
# frozen_string_literal: true

n = 0
program_sections = ARGF.each_line.each_with_object([]) do |line, sections|
  sections[n] ||= []
  sections[n] << line.chop
  n += 1 if line.start_with?('add z')
end.freeze

DIFFERENT_COMMANDS = program_sections.first.each_index.select do |idx|
  program_sections.map { _1[idx] }.uniq.count > 1
end.freeze
ARGUMENTS = program_sections.map do |section|
  DIFFERENT_COMMANDS.map { section[_1].split.last.to_i }
end.freeze

(1..2).each do |part|
  stack = []
  result = Array.new(14) { 0 }
  ARGUMENTS.each_with_index do |(command, arg2, arg3), idx|
    if command == 1
      stack.push([idx, arg3])
    else
      prev_idx, prev_arg = stack.pop
      diff = prev_arg + arg2

      result[prev_idx] = part == 1 ? [9 - diff, 9].min : [1 - diff, 1].max
      result[idx] = result[prev_idx] + diff
    end
  end
  puts "Part #{part}: #{result.join}"
end
