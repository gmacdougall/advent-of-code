#! /usr/bin/env ruby

class Num
  attr_reader :n
  attr_accessor :before, :after

  def initialize(n)
    @n = n
  end

  def inspect
    n
  end

  def move_right
    move(before, self, after, after.after)
  end

  def move_left
    move(before.before, before, self, after)
  end

  private

  def move(a, b, c, d)
    a.after = c

    c.before = a
    c.after = b

    b.before = c
    b.after = d

    d.before = b
  end
end

input = ARGF.map(&:strip).map { _1.scan(/-?\d+/).map(&:to_i) }.flatten.map { Num.new(_1 * 811589153) }

input.each_cons(2) do |a, b|
  a.after = b
  b.before = a
end

input.first.before = input.last
input.last.after = input.first

mod = input.length - 1
10.times do
  input.each do |num|
    if num.n < 0
      (num.n.abs % mod).times { num.move_left }
    else
      (num.n % mod).times { num.move_right }
    end
  end
end

val = 0

current = input.find { _1.n == 0 }
3.times do
  1000.times { current = current.after }
  val += current.n
end

p val
