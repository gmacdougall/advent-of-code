#! /usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

def lookup(registers, idx)
  Integer(idx)
rescue ArgumentError
  registers[idx]
end

def part1(instructions)
  sound = nil
  recover = nil
  registers = Hash.new(0)

  instruction_set = instructions.lines(chomp: true)
  pos = 0

  loop do
    parts = instruction_set[pos].split
    case parts[0]
    when 'snd'
      sound = registers[parts[1]]
    when 'set'
      registers[parts[1]] = lookup(registers, parts[2])
    when 'add'
      registers[parts[1]] += lookup(registers, parts[2])
    when 'mul'
      registers[parts[1]] *= lookup(registers, parts[2])
    when 'mod'
      registers[parts[1]] %= lookup(registers, parts[2])
    when 'rcv'
      return sound unless lookup(registers, parts[1]).zero?
    when 'jgz'
      pos += lookup(registers, parts[2]) - 1 if lookup(registers, parts[1]).positive?
    else
      fail
    end
    pos += 1
  end
  recover
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input'))}"
end

class MyTest < Minitest::Test
  def test_part1
    assert_equal(4, part1(File.read('sample')))
  end
end
