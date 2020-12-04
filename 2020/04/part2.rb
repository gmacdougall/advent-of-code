#!/usr/bin/env ruby

input = ARGF.read.split("\n\n").map do |line|
  Hash[line.split(' ').map { |field| field.split(':') }]
end

def validate_height?(hgt)
  (hgt&.end_with?('cm') && (150..193).include?(hgt.to_i)) ||
  (hgt&.end_with?('in') && (59..76).include?(hgt.to_i))
end

puts(
  input.count do |passport|
    [
      (1920..2002).include?(passport['byr'].to_i),
      (2010..2020).include?(passport['iyr'].to_i),
      (2020..2030).include?(passport['eyr'].to_i),
      %w[amb blu brn gry grn hzl oth].include?(passport['ecl']),
      validate_height?(passport['hgt']),
      passport['hcl']&.match?(/^#[0-9a-f]{6}$/),
      passport['pid']&.match?(/^[0-9]{9}$/),
    ].all?
  end
)
