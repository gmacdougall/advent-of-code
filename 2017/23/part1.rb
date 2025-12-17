#! /usr/bin/env ruby
# frozen_string_literal: true

def lookup(registers, idx)
  Integer(idx)
rescue ArgumentError
  registers[idx]
end

def part1(instructions)
  registers = Hash.new(0)

  instruction_set = instructions.lines(chomp: true)
  pos = 0
  multiply_instructions = 0

  while instruction_set[pos]
    parts = instruction_set[pos].split
    case parts[0]
    when 'set'
      registers[parts[1]] = lookup(registers, parts[2])
    when 'sub'
      registers[parts[1]] -= lookup(registers, parts[2])
    when 'mul'
      multiply_instructions += 1
      registers[parts[1]] *= lookup(registers, parts[2])
    when 'jnz'
      pos += lookup(registers, parts[2]) - 1 if lookup(registers, parts[1]) != 0
    else
      fail
    end
    pos += 1
  end
  multiply_instructions
end

puts "Part 1: #{part1(File.read('input'))}"
