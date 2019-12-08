#!/usr/bin/env ruby

ORIGINAL_MEM = ARGF.read.strip.split(',').map(&:to_i).freeze

def computer(inputs)
  mem = ORIGINAL_MEM.dup
  pos = 0
  outputs = []
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
      mem[mem[pos + 1]] = inputs.shift
      pos += 2
    when 4
      outputs << p1
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
      if p1 < p2
        mem[mem[pos + 3]] = 1
      else
        mem[mem[pos + 3]] = 0
      end
      pos += 4
    when 8
      if p1 == p2
        mem[mem[pos + 3]] = 1
      else
        mem[mem[pos + 3]] = 0
      end
      pos += 4
    else
      fail
    end
  end
  outputs.last
end

result = (0..4).to_a.permutation.map do |permutation|
  output = 0
  permutation.each do |num|
    output = computer([num, output])
  end
  output
end
puts result.max
