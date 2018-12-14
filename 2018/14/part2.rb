#!/usr/bin/env ruby

input = 793031
input_array = input.to_s.split('').map(&:to_i)

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
  if recipes[len - 1] == input_array[-1] &&
      recipes[len - 2] == input_array[-2] &&
      recipes[len - 3] == input_array[-3] &&
      recipes[len - 4] == input_array[-4] &&
      recipes[len - 5] == input_array[-5] &&
      recipes[len - 6] == input_array[-6]
    puts len - 6
    exit
  end

  len -= 1
  if recipes[len - 1] == input_array[-1] &&
      recipes[len - 2] == input_array[-2] &&
      recipes[len - 3] == input_array[-3] &&
      recipes[len - 4] == input_array[-4] &&
      recipes[len - 5] == input_array[-5] &&
      recipes[len - 6] == input_array[-6]
    puts len - 6
    exit
  end
end

