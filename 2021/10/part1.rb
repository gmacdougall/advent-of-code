#! /usr/bin/env ruby
# frozen_string_literal: true

CONTROL_CHARACTERS = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }.freeze
ERROR_VALUES = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }.freeze

syntax_errors = ARGF.each_with_object([]) do |line, err|
  stack = []
  corrupted = false
  line.strip.chars.each do |char|
    next if corrupted

    if CONTROL_CHARACTERS.keys.include?(char)
      stack.push char
    elsif stack.pop != CONTROL_CHARACTERS.key(char)
      corrupted = true
      err.push(char)
    end
  end
end

puts(syntax_errors.sum { ERROR_VALUES[_1] })
