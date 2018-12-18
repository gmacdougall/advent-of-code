#!/usr/bin/env ruby

require_relative './computer'

reg = Array.new(4, 0)

commands = [:eqir, :borr, :addr, :gtri, :muli, :gtir, :mulr, :banr, :bori, :eqri, :eqrr, :bani, :setr, :gtrr, :addi, :seti]

ARGF.each do |line|
  input = parse(line)
  OPERATIONS[commands[input.first]].call(reg, *input.last(3))
end

puts reg.first
