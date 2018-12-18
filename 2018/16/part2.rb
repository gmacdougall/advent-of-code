#!/usr/bin/env ruby

require_relative './computer'

results = []

ARGF.read.split("\n").reject(&:empty?).each_slice(3) do |slice|
  reg_before, commands, reg_after = slice.map { |str| parse(str) }

  opcode = commands.first

  potential = []

  OPERATIONS.each do |key, proc|
    reg = reg_before.dup
    proc.call(reg, *commands.last(3))

    potential << key if (reg == reg_after)
  end

  results[opcode] ||= []
  results[opcode] << potential
end

found_commands = []
16.times do
  results.each_with_index do |r, opcode|
    potential = r.flatten.uniq.reject { |c| found_commands.include?(c) }
    if potential.length == 1
      found_commands[opcode]= potential.first
    end
  end
end

puts found_commands.inspect
