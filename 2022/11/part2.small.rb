#! /usr/bin/env ruby

COUNT = 0; ITEMS = 1; MATH = 2; MOD = 3; IF_FALSE = 4; IF_TRUE =5

ALL = ARGF.read.split("\n\n").map do |l|
  s = l.lines
  [
    0,
    s[ITEMS].scan(/\d+/).map(&:to_i),
    (-> old { eval(s[MATH].split(?=)[1]) }),
  ] + l.scan(/\d+/).last(3).map(&:to_i)
end

10_000.times do
  ALL.each do |m|
    while item = m[ITEMS].shift
      m[COUNT] += 1
      item = m[MATH].call(item) % ALL.map { _1[MOD] }.inject(:*)
      ALL[item % m[MOD] == 0 ? m[IF_FALSE] : m[IF_TRUE]][ITEMS] << item
    end
  end
end

p ALL.map{_1[ITEMS]}.max(2).inject(:*)
