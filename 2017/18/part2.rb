#! /usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

class Program
  def initialize(instructions, id)
    @instructions = instructions
    @registers = Hash.new(0)
    @registers['p'] = id
    @pos = 0
    @id = id
    @@all ||= {}
    @@all[id] = self
    @buffer = []
    @sends = 0
  end

  attr_reader :instructions, :pos, :registers, :buffer, :sends

  def step
    parts = instructions[pos].split
    case parts[0]
    when 'snd'
      @sends += 1
      other.buffer << lookup(parts[1])
    when 'rcv'
      fail if buffer.empty?
      registers[parts[1]] = buffer.shift
    when 'set'
      registers[parts[1]] = lookup(parts[2])
    when 'add'
      registers[parts[1]] += lookup(parts[2])
    when 'mul'
      registers[parts[1]] *= lookup(parts[2])
    when 'mod'
      registers[parts[1]] %= lookup(parts[2])
    when 'jgz'
      @pos += lookup(parts[2]) - 1 if lookup(parts[1]).positive?
    else
      fail
    end
    @pos += 1
  end

  def can_run?
    buffer.any? || !instructions[pos].start_with?('rcv')
  end

  private

  def lookup(idx)
    Integer(idx)
  rescue ArgumentError
    registers[idx]
  end

  def other
    @other ||= @@all[@id.zero? ? 1 : 0]
  end
end

def part2(instructions)
  p0 = Program.new(instructions, 0)
  p1 = Program.new(instructions, 1)

  while p0.can_run? || p1.can_run?
    p0.step if p0.can_run?
    p1.step if p1.can_run?
  end
  p1.sends
end

puts "Part 2: #{part2(File.read('input').lines(chomp: true))}"
