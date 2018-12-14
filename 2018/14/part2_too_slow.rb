#!/usr/bin/env ruby

input = 793031

recipes = [3, 7]

elf1_index = 0
elf2_index = 1

while
  new = (recipes[elf1_index] + recipes[elf2_index]).to_s.split('').map(&:to_i)
  recipes.push(*new)

  elf1_index = (elf1_index + (recipes[elf1_index] + 1)) % recipes.length
  elf2_index = (elf2_index + (recipes[elf2_index] + 1)) % recipes.length

  len = recipes.length
  puts len if len % 10_000 == 0
  if recipes.last(7).join.include?(input.to_s)
    puts recipes.length
    puts recipes.last(7).join
    exit
  end
end
