#! /usr/bin/env ruby
# frozen_string_literal: true

OPCODE = {
  0 => :adv,
  1 => :bxl,
  2 => :bst,
  3 => :jnz,
  4 => :bxc,
  5 => :out,
  6 => :bdv,
  7 => :cdv
}.freeze

class Program
  attr_reader :reg_a, :reg_b, :reg_c, :instructions, :ptr, :output

  def initialize(reg_a, reg_b, reg_c, instructions)
    @reg_a = reg_a
    @reg_b = reg_b
    @reg_c = reg_c
    @instructions = instructions
    @ptr = 0
    @output = []
  end

  def combo(operand)
    case operand
    when 4
      reg_a
    when 5
      reg_b
    when 6
      reg_c
    when 7
      raise
    else
      operand
    end
  end

  def adv(val) = @reg_a = reg_a / 2**combo(val)
  def bxl(val) = @reg_b ^= val
  def bst(val) = @reg_b = combo(val) % 8

  def jnz(val)
    return if @reg_a.zero?

    @ptr = val - 2
  end

  def bxc(_) = @reg_b ^= reg_c
  def out(val) = @output << combo(val) % 8
  def bdv(val) = @reg_b = reg_a / 2**combo(val)
  def cdv(val) = @reg_c = reg_a / 2**combo(val)

  def call
    loop do
      op = OPCODE[instructions[ptr]]
      break unless op

      public_send(op, instructions[ptr + 1])
      @ptr += 2
    end
    output
  end
end

def parse(fname)
  reg_a, reg_b, reg_c, *instructions = File.read(fname).scan(/\d+/).map(&:to_i)
  Program.new(reg_a, reg_b, reg_c, instructions)
end

puts "Part 1: #{parse('input').call.join(',')}" if File.exist?('input')

require 'minitest/autorun'

class MyTest < Minitest::Test
  # If register C contains 9, the program 2,6 would set register B to 1.
  def test_bst
    program = Program.new(0, 0, 9, [2, 6])
    program.call
    assert_equal(1, program.reg_b)
  end

  # If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
  def test_out
    program = Program.new(10, 0, 0, [5, 0, 5, 1, 5, 4])
    assert_equal([0, 1, 2], program.call)
  end

  # If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A.
  def test_adv
    program = Program.new(2024, 0, 0, [0, 1, 5, 4, 3, 0])
    output = program.call
    assert_equal([4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0], output)
    assert_equal(0, program.reg_a)
  end

  # If register B contains 29, the program 1,7 would set register B to 26.
  def test_bxl
    program = Program.new(0, 29, 0, [1, 7])
    program.call
    assert_equal(26, program.reg_b)
  end

  # If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354.
  def test_bxc
    program = Program.new(0, 2024, 43_690, [4, 0])
    program.call
    assert_equal(44_354, program.reg_b)
  end

  def test_part1
    assert_equal('4635635210', parse('sample').call.join)
  end
end
