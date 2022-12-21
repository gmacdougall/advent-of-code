#! /usr/bin/env ruby

INPUT = ARGF.map(&:strip).map { _1.split(': ') }.to_h.transform_values do |val|
  val.match(/\d+/) ? val.to_i : val
end

def evaluate(val)
  if val.is_a? Integer
    val
  else
    a, op, b = val.split
    evaluate(INPUT[a]).send(op.to_sym, evaluate(INPUT[b]))
  end
end

low_bound = 1
upper_bound = 100_000_000_000_000

loop do
  puts "#{low_bound} - #{upper_bound}"
  mid = (upper_bound - low_bound) / 2 + low_bound
  INPUT['humn'] = mid
  result = evaluate(INPUT['root'].gsub('+', '<=>'))

  if result == 0
    puts mid
    exit
  elsif result > 0
    low_bound = mid
  else
    upper_bound = mid
  end
end
