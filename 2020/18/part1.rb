#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip).map { |l| l.chars.reject { |c| c == ' ' } }

def evaluate(expr)
  while expr.count > 1
    if expr.include?('(')
      paren_count = 1
      i = expr.index('(') + 1
      while !paren_count.zero?
        case expr[i]
        when '('
          paren_count += 1
        when ')'
          paren_count -= 1
        end
        i+=1
      end
      first = expr.index('(') + 1
      last = i - 2
      expr = expr[0...(first - 1)] + [evaluate(expr[first..last])] + expr[(last + 2)..]
    else
      p1, oper, p2 = expr.shift(3)
      result = p1.to_i.public_send(oper.to_sym, p2.to_i)
      expr.unshift(result)
    end
  end
  expr.first
end

sum = input.sum do |line|
  evaluate(line)
end

p sum
