#! /usr/bin/env ruby
# frozen_string_literal: true

# NOTE: This will only work for my input
def run(a)
  output = []
  while a.positive?
    b = a & 7 ^ 1
    output.push((a + 4) & 7 ^ (a >> b & 7))
    a >>= 3
  end
  output
end

TARGET = File.read('input').lines.last.scan(/\d/).map(&:to_i).freeze
def dfs(current, len)
  8.times.flat_map do |n|
    result = run(current + n)
    next unless result == TARGET.last(len)

    len < 16 ? dfs((current + n) << 3, len + 1) : current + n
  end.compact
end

p dfs(0, 0).min
