#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip)
RULES = input[0...input.index('')].map { |s| s.split(': ') }.to_h
values = input[(input.index('') + 1)..]

RULES['8'] = 'RULE_8'
RULES['11'] = 'RULE_11'

def resolve(rule)
  if rule == 'RULE_8'
    "(#{resolve('42')})+"
  elsif rule == 'RULE_11'
    "(?<rule11>#{resolve('42')}\\g<rule11>*#{resolve('31')})"
  elsif rule.start_with?('"')
    rule.gsub('"', '')
  elsif rule.include?(' | ')
    "(#{rule.split(' | ').map { |r| resolve(r) }.join('|')})"
  else
    rule.split(' ').map { |r| resolve(RULES.fetch(r)) }.join
  end
end

re = /^#{resolve(RULES.fetch('0'))}$/
p re
result = values.count { |val| val.match(re) }
p result
