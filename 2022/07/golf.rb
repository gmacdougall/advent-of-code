#! /usr/bin/env ruby

F=Hash.new(0)
D=[]
x=10**7

ARGF.map(&:split).map do |a, b, c|
  if a == '$'
    c == '..' ? D.pop : D.push(c) if b == 'cd'
  else
    (0..D.size).each { F[D.first(_1)] += a.to_i }
  end
end

p F.sum { _2 < 10**5 ? _2 : 0 }
p F.min_by { _2 > 3 * x - (7*x - F[[]]) ? _2: x}[1]
