#!/usr/bin/env ruby

INPUT = (ARGF.lines.map(&:strip).map(&:to_i) + [0]).sort
PATHS = {}

def go(val)
  # No Path
  return 0 unless INPUT.include?(val)

  # Base Case
  return 1 if val.zero?

  PATHS[val] ||= (1..3).sum { |i| go(val - i) }
end

go(INPUT.max)
p PATHS
