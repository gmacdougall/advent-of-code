#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip)
rules = {}
assigned_rules = {}

input.each do |line|
  break if line.empty?

  name, numbers = line.split(': ')
  rules[name] = numbers.split(' or ').map do |s|
    Range.new(*s.split('-').map(&:to_i))
  end
  assigned_rules[name] = nil
end

idx = input.index('your ticket:') + 1
my_ticket = input[idx].split(',').map(&:to_i)

idx = input.index('nearby tickets:') + 1
nearby_tickets = input[idx..].map { |s| s.split(',').map(&:to_i) }

valid_tickets = nearby_tickets.reject do |t|
  t.any? do |val|
    rules.values.all? do |ranges|
      ranges.none? do |range|
        range.include?(val)
      end
    end
  end
end

ticket_values = valid_tickets.length.times.map do |n|
  valid_tickets.map { |t| t[n] }
end

possibilities = rules.map do |rule, ranges|
  [
    rule,
    ticket_values.each_with_index.map do |values, idx|
      idx if values.all? { |v| ranges.any? { |r| r.include?(v) } }
    end.compact
  ]
end.to_h

while !assigned_rules.values.all?
  possibilities.each do |key, values|
    if values.count == 1
      assigned_rules[key] = values.first
    else
      assigned_rules.values.compact.each do |v|
        values.delete(v)
      end
    end
  end
end

p(
  assigned_rules.values.first(6).map do |idx|
    my_ticket[idx]
  end.inject(:*)
)
