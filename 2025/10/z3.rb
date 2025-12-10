#! /usr/bin/env ruby
# frozen_string_literal: true

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

input = parse('sample')

_, buttons, goal = input.first

solver = Z3::Optimize.new
b0 = Z3.Int("b0") # 3
b1 = Z3.Int("b1") # 1, 3
b2 = Z3.Int("b2") # 2
b3 = Z3.Int("b3") # 2, 3
b4 = Z3.Int("b4") # 0, 2
b5 = Z3.Int("b5") # 0, 1

solver.minimize(b0 + b1 + b2 + b3 + b4 + b5)

solver.assert(b0 >= 0)
solver.assert(b1 >= 0)
solver.assert(b2 >= 0)
solver.assert(b3 >= 0)
solver.assert(b4 >= 0)
solver.assert(b5 >= 0)

solver.assert(b4 + b5 == 3)
solver.assert(b1 + b5 == 5)
solver.assert(b2 + b3 + b4 == 4)
solver.assert(b0 + b1 + b3 == 7)

fail unless solver.check == :sat
p solver.model.to_h.values.sum.simplify
