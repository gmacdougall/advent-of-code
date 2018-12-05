#!/usr/bin/env ruby

def minute(line)
  line.match(/\d{4}-\d{2}-\d{2} \d{2}:(\d{2})/)[1].to_i
end

guard_schedule = Hash.new { |h, k| h[k] = Array.new(60, 0) }

guard, sleep_start = nil

ARGF.each do |line|
  if line.include?('begins shift')
    guard = line.match(/Guard #(\d+) begins shift/)[1].to_i
  elsif line.include?('falls asleep')
    sleep_start = minute(line)
  elsif line.include?('wakes up')
    sleep_end = minute(line)
    (sleep_start...sleep_end).each do |minute|
      guard_schedule[guard][minute] += 1
    end
  end
end

sleepiest_guard = guard_schedule.max_by { |k,v| v.sum }.first
sleepiest_minute = guard_schedule[sleepiest_guard].each_with_index.max[1]

puts "#{sleepiest_guard} * #{sleepiest_minute} = #{sleepiest_guard * sleepiest_minute}"
