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
    when 'tgl'
      to_mod = pos + lookup(registers, parts[1])

      unless instruction_set[to_mod]
        pos += 1
        next
      end
      mod_parts = instruction_set[to_mod].split
      if mod_parts.count == 2
        if mod_parts[0] == 'inc'
          mod_parts[0] = 'dec'
        else
          mod_parts[0] = 'inc'
        end
      else
        if mod_parts[0] == 'jnz'
          mod_parts[0] = 'cpy'
        else
          mod_parts[0] = 'jnz'
        end
      end
      instruction_set[to_mod] = mod_parts.join(' ')
    else
      fail
    end
    pos += 1
  end
  registers['a']
end

puts "Part 1: #{sol(File.read('input'), 7)}"
# This works, but is really slow
puts "Part 2: #{sol(File.read('input'), 12)}"
