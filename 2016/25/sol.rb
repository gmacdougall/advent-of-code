#! /usr/bin/env ruby
# frozen_string_literal: true

def lookup(registers, idx)
  Integer(idx)
rescue ArgumentError
  registers[idx]
end

def sol(instructions, a)
  registers = Hash.new(0)
  registers['a'] = a

  instruction_set = instructions.lines(chomp: true)
  pos = 0
  expected = 0
  success = 0

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
    when 'out'
      val = lookup(registers, parts[1])
      return false if val != expected

      expected = expected == 0 ? 1 : 0
      success += 1
      return true if success > 1000
    else
      fail
    end
    pos += 1
  end
end

(0..).each do |n|
  result = sol(File.read('input'), n)
  puts "#{n}: #{result}"
  break if result
end
