#! /usr/bin/env ruby

require 'set'

input = ARGF.map(&:strip).map { _1.gsub(',', '').split }.map do |_, valve, _, _, flow_rate, _, _, _, _, *valves|
  [valve, { rate: flow_rate.scan(/\d+/).first.to_i, to: valves }]
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
  key if v[:rate] > 11
end

result = non_empty.permutation.map do |order|
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
  output
end

p result.max
