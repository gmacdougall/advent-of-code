#!/usr/bin/env ruby

input = 793031
input_str = input.to_s

recipes = [3, 7]

elf1_index = 0
elf2_index = 1

last7 = Array.new(7)

while
  new = (recipes[elf1_index] + recipes[elf2_index]).to_s.split('').map(&:to_i)
  recipes.push(*new)
  last7.push(*new)
  last7.shift(new.length)

  elf1_index = (elf1_index + (recipes[elf1_index] + 1)) % recipes.length
  elf2_index = (elf2_index + (recipes[elf2_index] + 1)) % recipes.length

  len = recipes.length
  puts len if len % 10_000 == 0

  if (last7.join.include?(input_str))
    puts len
    puts last7.join
    exit
  end
end

