#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require 'z3'

def parse(fname)
  File.read(fname).lines(chomp: true).map do |line|
    a, *b, c = line.split(' ')
    [
      a.chars[1..-2].map { it == '#' },
      b.map { it.scan(/\d/).map(&:to_i) },
      c.scan(/\d+/).map(&:to_i)
    ]
  end
end

def press(state, buttons)
  buttons.each { state[it] = !state[it] }
  state
end

def part1(input)
  input.sum do |goal, buttons|
    seen = Set.new([Array.new(goal.length) { false }])

    i = 0
    while !seen.include?(goal)
      i += 1
      to_add = []
      seen.map do |state|
        buttons.map do |button|
          result = press(state.dup, button)
          to_add << result unless seen.include?(result)
        end
      end

      raise if to_add.empty?
      to_add.each { seen << it }
    end
    i
  end
end

def part2(input)
  input.sum do |_, buttons, goal|
    solver = Z3::Optimize.new
    btns = buttons.length.times.map { Z3.Int("b#{_1}") }

    solver.minimize(btns.sum)
    btns.each { solver.assert(_1 >= 0) }

    goal.each_with_index do |target, gi|
      to_push = buttons.each_index.filter_map do |bi|
        btns[bi] if buttons[bi].include?(gi)
      end
      solver.assert(to_push.sum == target)
    end

    fail unless solver.check == :sat
    solver.model.to_h.values.sum.simplify.to_i
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(7, part1(parse('sample')))
  end

  def test_part2
    assert_equal(33, part2(parse('sample')))
  end
end
