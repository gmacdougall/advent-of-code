#! /usr/bin/env ruby
# frozen_string_literal: true

CONTROL_CHARACTERS = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }.freeze
AUTOCOMPLETE = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }.freeze

def parse(line)
  line.strip.chars.each_with_object([]) do |char, stack|
    if CONTROL_CHARACTERS.keys.include?(char)
      stack.push char
    elsif stack.pop != CONTROL_CHARACTERS.key(char)
      return nil
    end
  end
end

scores = ARGF.map do |line|
  parse(line)&.reverse&.inject(0) { |score, c| (score * 5) + AUTOCOMPLETE[c] }
end.compact.sort

puts scores[scores.length / 2]
