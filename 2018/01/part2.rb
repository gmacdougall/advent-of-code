#!/usr/bin/env ruby

numbers = ARGF.map(&:to_i)

found = []
overall_drift = 0

1000.times do
  overall_drift = numbers.inject(overall_drift) do |drift, n|
    drift += n
    if found.include?(drift)
      puts drift
      exit
    else
      found << drift
    end
    drift
  end
end
