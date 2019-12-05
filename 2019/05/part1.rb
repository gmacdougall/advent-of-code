#!/usr/bin/env ruby

original_mem = File.read('input').strip.split(',').map(&:to_i)

mem = original_mem.dup
pos = 0

while (mem[pos] != 99)
  full_opcode = mem[pos].to_s.rjust(5, '0').chars
  op = full_opcode.last(2).join.to_i

  p1 = mem[pos + 1].to_i
  p2 = mem[pos + 2].to_i
  p3 = mem[pos + 3].to_i

  p3 = mem[p3] if full_opcode[0] == '0'
  p2 = mem[p2] if full_opcode[1] == '0'
  p1 = mem[p1] if full_opcode[2] == '0'

  case op
  when 1
    mem[mem[pos + 3]] = p1 + p2
    pos += 4
  when 2
    mem[mem[pos + 3]] = p1 * p2
    pos += 4
  when 3
    puts "Input: "
    mem[mem[pos + 1]] = gets.strip.to_i
    pos += 2
  when 4
    puts mem[mem[pos + 1]]
    pos += 2
  else
    fail
  end
end
