#!/usr/bin/env ruby

require_relative '../16/computer'

reg = Array.new(6, 0)
ip = 1

reg[0] = 10846352

instructions = []

ARGF.each do |line|
  if line.start_with?('#ip')
    ip = line.split(' ').last.to_i
  else
    op, *inputs = line.split(' ')
    instructions << [op.to_sym, *inputs.map(&:to_i)]
  end
end

instruction_count = 0
while i = instructions[reg[ip]]
  OPERATIONS[i.first].call(reg, *i.last(3))
  reg[ip] += 1
  puts "#{i.first} #{i.last(3).inspect} #{reg}"
  instruction_count += 1
  break if i.first == 'eqrr'
end

puts reg.inspect
puts instruction_count
