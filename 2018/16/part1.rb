#!/usr/bin/env ruby

require_relative './computer'

results = []

ARGF.read.split("\n").reject(&:empty?).each_slice(3) do |slice|
  reg_before, commands, reg_after = slice.map { |str| parse(str) }

  potential = []

  OPERATIONS.each do |key, proc|
    reg = reg_before.dup
    proc.call(reg, *commands.last(3))

    potential << key if (reg == reg_after)
  end
  results << potential
end

puts results.select { |r| r.length >= 3 }.count
