#!/usr/bin/env ruby

input = ARGF.read.split("\n\n").map do |line|
  Hash[line.split(' ').map { |field| field.split(':') }]
end

REQUIRED_FIELDS = %w[
  byr
  iyr
  eyr
  hgt
  hcl
  ecl
  pid
]

puts(
  input.count do |passport|
    (REQUIRED_FIELDS - passport.keys).empty?
  end
)
