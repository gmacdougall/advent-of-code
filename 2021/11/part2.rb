#! /usr/bin/env ruby
# frozen_string_literal: true

@state = ARGF.read.gsub("\n", '').to_i.digits

def increment(idx)
  x = idx % 10
  y = idx / 10
  @state[idx] += 1
  return unless @state[idx] == 10

  (-1..1).each do |dx|
    (-1..1).each do |dy|
      next unless (0..9).cover?(x + dx) && (0..9).cover?(y + dy)

      increment(idx + (dy * 10) + dx)
    end
  end
end

puts(
  (1..).find do
    100.times { increment _1 }
    @state.map! { |n| n > 9 ? 0 : n }
    @state.all?(&:zero?)
  end
)
