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
    elsif expr.length > 3 && (expr.include?('+') || expr.include?('-'))
      oper_idx = [expr.index('+'), expr.index('-')].compact.min
      expr = expr[0...(oper_idx - 1)] +
        [evaluate(expr[(oper_idx - 1)..(oper_idx + 1)])] +
        expr[(oper_idx + 2)..]
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
