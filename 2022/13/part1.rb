#! /usr/bin/env ruby

input = ARGF.read.split("\n\n").map { |i| i.lines.map { eval(_1) } }

def compare(a, b)
  if a.is_a?(Integer) && b.is_a?(Integer)
    return nil if a == b
    return a < b
  elsif a.is_a?(Array) && b.is_a?(Array)
    a.each_index do |idx|
      break if !b[idx]
      res = compare(a[idx], b[idx])
      return res unless res.nil?
    end
    return nil if a.length == b.length
    return a.length < b.length
  elsif a.is_a?(Array) && b.is_a?(Integer)
    return compare(a, [b])
  elsif a.is_a?(Integer) && b.is_a?(Array)
    return compare([a], b)
  end
end

p input.each_with_index.map { |(a, b), idx| idx + 1 if compare(a, b) }.compact.sum
