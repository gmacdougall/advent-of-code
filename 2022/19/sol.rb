#! /usr/bin/env ruby

input = ARGF.map(&:strip).map { _1.scan(/-?\d+/).map(&:to_i) }

def dfs(to_buy, minutes_remaining, rR, rC, rO, rG, r, c, o, g)
  minutes_remaining -= 1

  buy = (to_buy == :geode && $cGr <= r && $cGo <= o) ||
    (to_buy == :obs && $cOr <= r && $cOc <= c) ||
    (to_buy == :clay && $cCr <= r) ||
    (to_buy == :ore && $cRr <= r)

  r += rR
  c += rC
  o += rO
  g += rG

  return g if minutes_remaining == 0
  return dfs(to_buy, minutes_remaining, rR, rC, rO, rG, r, c, o, g) unless buy

  case to_buy
  when :ore
    rR += 1
    r -= $cRr
  when :clay
    rC += 1
    r -= $cCr
  when :obs
    rO += 1
    r -= $cOr
    c -= $cOc
  when :geode
    rG += 1
    r -= $cGr
    o -= $cGo
  end

  if minutes_remaining > 3
    todo = [dfs(:geode, minutes_remaining, rR, rC, rO, rG, r, c, o, g)]
    todo << dfs(:ore, minutes_remaining, rR, rC, rO, rG, r, c, o, g) unless rR >= $cRr && rR >= $cCr && rR >= $cOr && rR > $cGr
    todo << dfs(:clay, minutes_remaining, rR, rC, rO, rG, r, c, o, g) unless rC >= $cOc
    todo << dfs(:obs, minutes_remaining, rR, rC, rO, rG, r, c, o, g) unless rO >= $cGo
    return todo.max
  else
    dfs(:geode, minutes_remaining, rR, rC, rO, rG, r, c, o, g)
  end
end

result = input.map do |props|
  _, $cRr, $cCr, $cOr, $cOc, $cGr, $cGo = props
  [:ore, :clay].map { dfs(_1, 24, 1, 0, 0, 0, 0, 0, 0, 0) }.max
end
p result.each_with_index.sum { _1 * (_2 + 1) }

result = input.first(3).map do |props|
  _, $cRr, $cCr, $cOr, $cOc, $cGr, $cGo = props
  [:ore, :clay].map { dfs(_1, 32, 1, 0, 0, 0, 0, 0, 0, 0) }.max
end
p result.inject(:*)
