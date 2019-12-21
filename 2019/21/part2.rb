#!/usr/bin/env ruby

original_mem = File.read('program').strip.split(',').map(&:to_i)

mem = Hash.new { 0 }
original_mem.each_with_index do |v, k|
  mem[k] = v
end
pos = 0
relative_base = 0

# !a && !b && !c && d ||
# a && !b

script = """
NOT A J
NOT B T
OR T J
NOT C T
OR T J
AND D J
NOT E T
AND H T
OR E T
AND T J
RUN
""".strip + "\n"

input = script.bytes
output = []

def set_mem(mem, addr, value)
  #puts "Setting #{addr} to #{value}"
  mem[addr] = value
end

while (mem[pos] != 99)
  full_opcode = mem[pos].to_s.rjust(5, '0').chars
  op = full_opcode.last(2).join.to_i

  p1 = mem[pos + 1].to_i
  address_p1 = p1
  p2 = mem[pos + 2].to_i
  p3 = mem[pos + 3].to_i
  address_p3 = p3

  if full_opcode[0] == '0'
    p3 = mem[p3]
  elsif full_opcode[0] == '2'
    address_p3 = relative_base + p3
    p3 = mem[relative_base + p3]
  end

  if full_opcode[1] == '0'
    p2 = mem[p2]
  elsif full_opcode[1] == '2'
    p2 = mem[relative_base + p2]
  end

  if full_opcode[2] == '0'
    p1 = mem[p1]
  elsif full_opcode[2] == '2'
    address_p1 = relative_base + p1
    p1 = mem[relative_base + p1]
  end

  case op
  when 1
    require 'pry'
    binding.pry if p1.nil?
    set_mem(mem, address_p3, p1 + p2)
    pos += 4
  when 2
    set_mem(mem, address_p3, p1 * p2)
    pos += 4
  when 3
    set_mem(mem, address_p1, input.shift)
    pos += 2
  when 4
    output << p1
    pos += 2
  when 5
    if p1 != 0
      pos = p2
    else
      pos += 3
    end
  when 6
    if p1 == 0
      pos = p2
    else
      pos += 3
    end
  when 7
    set_mem(mem, address_p3, (p1 < p2 ? 1 : 0))
    pos += 4
  when 8
    set_mem(mem, address_p3, (p1 == p2 ? 1 : 0))
    pos += 4
  when 9
    relative_base += p1
    pos += 2
  else
    fail
  end
end

puts output.last
