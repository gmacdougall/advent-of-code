#! /usr/bin/env ruby
# frozen_string_literal: true

BUS_IDS = ARGF.lines.map(&:strip).last.split(',').map(&:to_i)
RUNNING_BUS_IDS = BUS_IDS.reject(&:zero?)

start = 0
increment = 1

RUNNING_BUS_IDS.length.times do |num|
  bus_ids = RUNNING_BUS_IDS.sort.last(num + 1)

  start = (start..).step(increment).find do |time|
    bus_ids.all? { |id| ((time + BUS_IDS.index(id)) % id).zero? }
  end

  increment = bus_ids.inject(1, &:lcm)
end

p start
