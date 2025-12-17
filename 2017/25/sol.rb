#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).split("\n\n")
end

def call(input)
  init, *instructions = input

  state, steps = init.match(/Begin in state (.).\nPerform a diagnostic checksum after (\d+) steps./).captures
  steps = Integer(steps)

  tape = Hash.new(0)
  pos = 0

  program = {}
  instructions.each do |inst|
    foo = inst.match(/In state (.):\n  If the current value is (.):\n    - Write the value (.).\n    - Move one slot to the (\w+)\.\n    - Continue with state (.)\.\n  If the current value is (.):\n    - Write the value (.).\n    - Move one slot to the (\w+).\n    - Continue with state (.)/).captures

    program[foo[0]] = {
      foo[1].to_i => { write: foo[2].to_i, move: foo[3], state: foo[4] },
      foo[5].to_i => { write: foo[6].to_i, move: foo[7], state: foo[8] },
    }
  end

  steps.times do
    prog = program[state][tape[pos]]
    tape[pos] = prog[:write]
    pos += prog[:move] == "right" ? 1 : -1
    state = prog[:state]
  end
  tape.values.sum
end

if File.exist?('input')
  puts "Part 1: #{call(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_call
    assert_equal(3, call(parse('sample')))
  end
end
