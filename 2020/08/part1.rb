#!/usr/bin/env ruby

input = ARGF.read.lines.map(&:strip).freeze
ptr = 0
acc = 0

visited = []
while !visited.include?(ptr)
  visited << ptr
  instruction = input[ptr].split(' ')
  val = instruction.last.to_i

  case instruction.first
  when 'jmp'
    ptr += val
  when 'acc'
    acc += val
    ptr += 1
  when 'nop'
    ptr += 1
  else
    puts instruction
    raise
  end
end

p acc
