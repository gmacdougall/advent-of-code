#! /usr/bin/env ruby
require 'set'

input = ARGF.map(&:strip).map { _1.scan(/-?\d+/).map(&:to_i) }
set = Set.new(input)

count = 0

set.each do |x, y, z|
  count += 1 unless set.include?([x + 1, y, z])
  count += 1 unless set.include?([x - 1, y, z])
  count += 1 unless set.include?([x, y + 1, z])
  count += 1 unless set.include?([x, y - 1, z])
  count += 1 unless set.include?([x, y, z + 1])
  count += 1 unless set.include?([x, y, z - 1])
end

p count
