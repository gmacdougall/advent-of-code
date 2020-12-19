#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip)
RULES = input[0...input.index('')].map { |s| s.split(': ') }.to_h
values = input[(input.index('') + 1)..]

def resolve(rule)
  if rule.start_with?('"')
    rule.gsub('"', '')
  elsif rule.include?(' | ')
    "(#{rule.split(' | ').map { |r| resolve(r).join }.join('|')})"
  else
    rule.split(' ').map do |r|
      resolve(RULES.fetch(r))
    end
  end
end

re = /^#{resolve(RULES.fetch('0')).join}$/
p(values.count { |val| val.match(re) })
