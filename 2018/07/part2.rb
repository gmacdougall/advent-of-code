#!/usr/bin/env ruby

def time(letter)
  letter.ord - 4
end

prereqs = {}

('A'..'Z').each do |letter|
  prereqs[letter] = []
end

ARGF.each do |line|
  parts = line.split(' ')

  prereqs[parts[7]] <<  parts[1]
end

start_and_finish = {}
complete = []
number_of_workers = 5

1000.times do |tick|
  complete = start_and_finish.map { |key, val| key if val[:finish] < tick }.compact

  prereqs.select do |key, values|
    values.reject { |val| complete.include?(val) }.empty?
  end.keys.each do |letter|
    if !start_and_finish[letter] # && current_in_progress_tasks < number_of_workers
      start_and_finish[letter] = { start: tick, finish: tick + time(letter) - 1}
      puts start_and_finish.inspect
    end
  end

  current_in_progress_tasks = start_and_finish.values.count do |set|
    tick.between?(set[:start], set[:finish])
  end

  puts "#{tick} - #{current_in_progress_tasks}"

end
puts start_and_finish.inspect
