#! /usr/bin/env ruby
# frozen_string_literal: true

def lookup(registers, idx)
  Integer(idx)
rescue ArgumentError
  registers[idx]
end

def part1(instructions, c = 0)
  registers = Hash.new(0)
  registers['c'] = c

  instruction_set = instructions.lines(chomp: true)
  pos = 0

  while instruction_set[pos]
    parts = instruction_set[pos].split
    case parts[0]
    when 'inc'
      registers[parts[1]] += 1
    when 'dec'
      registers[parts[1]] -= 1
    when 'cpy'
      registers[parts[2]] = lookup(registers, parts[1])
    when 'jnz'
      pos += lookup(registers, parts[2]) - 1 if lookup(registers, parts[1]) != 0
    else
      fail
    end
    pos += 1
  end
  registers['a']
end

puts "Part 1: #{part1(File.read('input'))}"
puts "Part 2: #{part1(File.read('input'), 1)}"
