#! /usr/bin/env ruby

require 'set'
require 'pry'

class Valve
  attr_reader :name, :rate, :to
  attr_accessor :visited, :distance, :current_rate

  def initialize(name, rate, to)
    @name = name
    @rate = rate
    @to = to
    self.class.all[name] = self

    @total_flow_rate = 0
    @distance = 0
    @minutes_remaining = 0
  end

  def self.all
    @all ||= {}
  end
end

input = ARGF.map(&:strip).map { _1.gsub(',', '').split }.map do |_, name, _, _, rate, _, _, _, _, *to|
  [name, { rate: rate.scan(/\d+/)[0].to_i, to: }]
end.to_h
TOTAL = 30

PATHS = {}
input.keys.each do |position|
  distances = {}
  to_check = Set.new
  to_check << [position, []]

  while props = to_check.first
    v, d = props
    to_check.delete(props)
    distances[v] = d
    input[v][:to].each do |n|
      to_check << [n, d + [n]] unless distances.has_key?(n)
    end
  end
  PATHS[position] = distances
end

non_empty = input.filter_map do |key, v|
  key if v[:rate] > 0
end

simple_paths = {}

(["AA"] + non_empty).each do |start|
  non_empty.reject { _1 == start }.each do |finish|
    if PATHS[start][finish].select { non_empty.include?(_1) }.first == finish
      simple_paths[start] ||= {}
      simple_paths[start][finish] = PATHS[start][finish].find_index(finish) + 1
    end
  end
end

binding.pry
exit

current = 'AA'
best_order = []
while non_empty.length >= 2
  what = non_empty.combination(2).map do |a, b|
    p [a, b]
    a_then_b = (30 - PATHS[current][a].length - 1) * input[a][:rate] + (30 - PATHS[current][a].length - PATHS[a][b].length - 2) * input[b][:rate]
    b_then_a = (30 - PATHS[current][b].length - 1) * input[b][:rate] + (30 - PATHS[current][b].length - PATHS[b][a].length - 2) * input[a][:rate]

    if b_then_a > a_then_b
      [b, a, b_then_a]
    else
      [a, b, a_then_b]
    end
  end

  best, _, _ = what.max_by(&:last)
  best_order << best
  non_empty.delete(best)
  current = best
end

order = best_order + non_empty

position = 'AA'
time_remaining = 30
output = 0
goto = order.shift
open = []

while time_remaining > 0
  open.each do |key|
    valve = input[key]
    output += valve[:rate]
  end

  if goto.nil?
    # no-op
  elsif (goto == position)
    open << goto
    goto = order.shift
  else
    position = PATHS[position][goto].first
  end
  time_remaining -= 1
end
p output
