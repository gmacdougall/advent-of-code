#! /usr/bin/env ruby
# frozen_string_literal: true

INPUT = ARGF.map { |line| line.chop.split('-') }.flat_map { [_1, _1.reverse] }
SMALL_CAVES = INPUT.flatten.select { _1.match /[a-z]+/ }

results = []
paths = [['start']]
while (path = paths.pop)
  if path.last == 'end'
    results << path
  else
    INPUT
      .select { |start, _| start == path.last }
      .map(&:last)
      .reject { |dest| dest == 'start' }
      .map { |dest| path + [dest] }
      .reject do |p|
        small_caves = p.select { |node| SMALL_CAVES.include?(node) }
        small_caves.uniq.length < (small_caves.length - 1)
      end.each { paths.push(_1) }
  end
end

puts results.count
