#! /usr/bin/env ruby
# frozen_string_literal: true

def solve(a)
  b = 0
  if a == 1
    a *= 3
    a += 1
    a += 1
    a *= 3
    a += 1
    a += 1
    a *= 3
    a *= 3
    a += 1
    a += 1
    a *= 3
    a += 1
    a *= 3
    a += 1
    a *= 3
    a += 1
    a += 1
    a *= 3
    a += 1
    a *= 3
    a *= 3
    a += 1
  else
    a += 1
    a += 1
    a *= 3
    a *= 3
    a *= 3
    a += 1
    a += 1
    a *= 3
    a += 1
    a += 1
    a *= 3
    a *= 3
    a *= 3
    a += 1
  end
  loop do
    if a == 1
      puts b
      exit
    end
    b += 1
    if a.odd?
      a *= 3
      a += 1
    else
      a /= 2
    end
  end
end

puts "Part 1: #{solve(0)}"
puts "Part 2: #{solve(1)}"
