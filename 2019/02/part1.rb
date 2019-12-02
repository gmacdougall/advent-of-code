#!/usr/bin/env ruby

code = ARGF.read.strip.split(',').map(&:to_i)
pos = 0

code[1] = 12
code[2] = 2

while (code[pos] != 99)
  op = code[pos]
  p1 = code[pos + 1]
  p2 = code[pos + 2]
  store = code[pos + 3]

  if op == 1
    code[store] = code[p1] + code[p2]
  elsif code[pos] == 2
    code[store] = code[p1] * code[p2]
  else
    fail
  end
  pos += 4
end

puts code.inspect
