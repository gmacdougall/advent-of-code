#! /usr/bin/env ruby
# frozen_string_literal: true

arr = ARGF.read.strip.chars.map(&:to_i) + (10..1_000_000).to_a
RANGE = Range.new(*arr.minmax)

class Node
  attr_reader :n
  attr_accessor :next

  def initialize(n)
    @n = n
  end

  def inspect
    "<Node: #{n} -> #{@next.n}>"
  end

  def take
    @next.tap { @next = @next.next.next.next }
  end

  def to_exclude
    [n, @next.n, @next.next.n]
  end

  def insert_right(node)
    target = @next
    @next = node
    @next.next.next.next = target
  end
end

NODES = arr.inject({}) { |hash, n| hash.tap { |h| h[n] = Node.new(n) } }
NODES.values.each_cons(2) { |left, right| left.next = right }

current = NODES.values.first
NODES.fetch(RANGE.max).next = current

10_000_000.times do
  taken_node = current.take
  excluded = taken_node.to_exclude
  destination_n = current.n - 1

  while excluded.include?(destination_n) || destination_n < RANGE.min
    destination_n = RANGE.max if destination_n < RANGE.min
    destination_n -= 1 if excluded.include?(destination_n)
  end

  NODES.fetch(destination_n).insert_right(taken_node)
  current = current.next
end

n = NODES.fetch(1)
puts n.next.n * n.next.next.n
