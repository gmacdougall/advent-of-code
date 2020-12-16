#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip)
rules = {}

input.each do |line|
  break if line.empty?

  name, numbers = line.split(': ')
  rules[name] = numbers.split(' or ').map do |s|
    Range.new(*s.split('-').map(&:to_i))
  end
end

idx = input.index('your ticket:') + 1
my_ticket = input[idx].split(',').map(&:to_i)

idx = input.index('nearby tickets:') + 1
nearby_tickets = input[idx..].map { |s| s.split(',').map(&:to_i) }

result = nearby_tickets.flat_map do |t|
  t.select do |val|
    rules.values.all? do |ranges|
      ranges.none? do |range|
        range.include?(val)
      end
    end
  end
end

p result.sum
