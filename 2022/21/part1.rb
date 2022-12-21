#! /usr/bin/env ruby

INPUT = ARGF.map(&:strip).map { _1.split(': ') }.to_h.transform_values do |val|
  val.match(/\d+/) ? val.to_i : val
end.freeze

def evaluate(val)
  if val.is_a? Integer
    val
  else
    a, op, b = val.split
    evaluate(INPUT[a]).send(op.to_sym, evaluate(INPUT[b]))
  end
end

puts evaluate(INPUT['root'])
