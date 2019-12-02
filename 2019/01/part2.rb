#!/usr/bin/env ruby

def total(weight)
  result = 0
  last = fuel(weight)
  while (last > 0)
    result += last
    last = fuel(last)
  end
  result
end

def fuel(weight)
  [0, (weight.to_i / 3) - 2].max
end

puts ARGF.sum { |arg| total(arg.to_i) }
