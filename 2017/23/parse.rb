#! /usr/bin/env ruby
# frozen_string_literal: true

File.read('input').lines.each do |line|
  parts = line.split(' ')
  case parts[0]
  when 'set'
    puts "#{parts[1]} = #{parts[2]}"
  when 'mul'
    puts "#{parts[1]} *= #{parts[2]}"
  when 'sub'
    op = parts[2].to_i
    if op.negative?
      puts "#{parts[1]} += #{op.abs}"
    else
      puts "#{parts[1]} -= #{parts[2]}"
    end
  else
    puts line
  end
end
