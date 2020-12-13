#! /usr/bin/env ruby
# frozen_string_literal: true

BUS_IDS = ARGF.lines.map(&:strip).last.split(',').map(&:to_i)
RUNNING_BUS_IDS = BUS_IDS.reject(&:zero?)

start = 0
increment = 1

RUNNING_BUS_IDS.length.times do |num|
  bus_ids = RUNNING_BUS_IDS.first(num + 1)

  start, last = (start..10**100).step(increment).lazy.select do |time|
    bus_ids.all? { |id| ((time + BUS_IDS.index(id)) % id).zero? }
  end.first(2)

  increment = last - start
end

p start
