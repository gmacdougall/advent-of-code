#! /usr/bin/env ruby
# frozen_string_literal: true

INPUT = ARGF.map { |line| line.chop.split('-') }.flat_map { [_1, _1.reverse] }

results = []
paths = [['start']]
while (path = paths.pop)
  if path.last == 'end'
    results << path
  else
    INPUT
      .select { |s, _| s == path.last }
      .map(&:last)
      .reject { |node| node.match?(/[a-z]+/) && path.include?(node) }
      .each { paths.push(path + [_1]) }
  end
end

puts results.count
