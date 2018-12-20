#!/usr/bin/env ruby

require_relative '../16/computer'

reg = Array.new(6, 0)
ip = 0

instructions = []

ARGF.each do |line|
  if line.start_with?('#ip')
    ip = line.split(' ').last.to_i
  else
    op, *inputs = line.split(' ')
    instructions << [op.to_sym, *inputs.map(&:to_i)]
  end
end

while i = instructions[reg[ip]]
  OPERATIONS[i.first].call(reg, *i.last(3))
  reg[ip] += 1
end

puts reg
