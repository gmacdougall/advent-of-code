#! /usr/bin/env ruby
# frozen_string_literal: true

def look_and_say(str)
  str.chars.chunk_while { _1 == _2 }.map { "#{_1.count}#{_1.first}" }.join
end

val = '3113322113'
(1..50).each do |n|
  val = look_and_say(val)
  puts "#{n}: #{val.length}"
end
