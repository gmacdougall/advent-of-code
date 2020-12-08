#!/usr/bin/env ruby

input = ARGF.read.lines.map(&:strip).map { |a| a.split(' ') }.freeze

def run(input)
  ptr = 0
  acc = 0

  visited = []
  while !visited.include?(ptr) && ptr < input.length
    visited << ptr
    instruction = input[ptr]
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
  p acc if ptr == input.length
end

input.length.times.each do |n|
  i = input.dup
  i[n] = i[n].dup
  case i[n].first
  when 'jmp'
    i[n][0] = 'nop'
  when 'nop'
    i[n][0] = 'jmp'
  end
  run i
end
