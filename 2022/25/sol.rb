#! /usr/bin/env ruby

input = ARGF.map(&:strip).map { _1.chars }

def snafu(line)
  line.reverse.map do |c|
    case c
    when '2', '1', '0'
      c.to_i
    when '-'
      -1
    when '='
      -2
    end
  end.each_with_index.sum { |n, idx| n * (5 ** idx) }
end

current = input.sum { snafu _1 }
results = []

while current > 5
  results << current % 5
  current /= 5
end
results << current

(0...results.size).each do |idx|
  if results[idx] > 2
    results[idx] -= 5
    results[idx+1] += 1
  end
end

puts(
  results.reverse.map do |n|
    case n
    when -1
      '-'
    when -2
      '='
    else
      n.to_i
    end
  end.join
)
