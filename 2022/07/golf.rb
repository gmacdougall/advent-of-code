#! /usr/bin/env ruby

F=Hash.new(0)
D=[]
x=10**7

ARGF.map(&:split).map do |a, b, c|
  if a == '$'
    c == '..' ? D.pop : D << c if b == 'cd'
  else
    (0..D.size).each { F[D.first(_1)] += a.to_i }
  end
end

g=F.values

p g.select { _1 < 10**5 }.sum,g.select { _1 > 3*x - (7*x - F[[]]) }.min
