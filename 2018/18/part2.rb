#!/usr/bin/env ruby

require 'digest'

OPEN = '.'.freeze
TREES = '|'.freeze
LUMBERYARD = '#'.freeze

ground = ARGF.map do |line|
  line.strip.split('')
end

def print(ground)
  ground.each do |line|
    puts line.join
  end
  puts "\n"
end

def digest(ground)
  Digest::SHA1.digest(ground.flatten.join)
end

MAX_X = ground.first.length - 1
MAX_Y = ground.length - 1

previous_states = {}
previous_states[digest(ground)] = 0

more_times = nil

100_000.times do |n|
  new_ground = ground.each_with_index.map do |line, y|
    line.each_with_index.map do |chr, x|
      adjacent = []

      adjacent << ground[y + 1][x] unless y == MAX_Y
      adjacent << ground[y + 1][x - 1] unless y == MAX_Y || x == 0
      adjacent << ground[y + 1][x + 1] unless y == MAX_Y || x == MAX_X
      adjacent << ground[y - 1][x] unless y == 0
      adjacent << ground[y - 1][x - 1] unless y == 0 || x == 0
      adjacent << ground[y - 1][x + 1] unless y == 0 || x == MAX_X
      adjacent << ground[y][x + 1] unless x == MAX_X
      adjacent << ground[y][x - 1] unless x == 0

      case chr
      when OPEN
        if adjacent.count { |a| a == TREES } >= 3
          TREES
        else
          chr
        end
      when TREES
        if adjacent.count { |a| a == LUMBERYARD } >= 3
          LUMBERYARD
        else
          chr
        end
      when LUMBERYARD
        if adjacent.any? { |a| a == LUMBERYARD } && adjacent.any? { |a| a == TREES }
          chr
        else
          OPEN
        end
      end
    end
  end
  ground = new_ground
  d = digest(ground)

  if more_times.nil?
    if previous_states[d]
      more_times = (1000000000 - previous_states[d]) % (n - previous_states[d]) - 1
    else
      previous_states[d] = n
    end
  else
    more_times -= 1
    break if more_times == 0
  end
end

lumberyards =  ground.flatten.count { |chr| chr == LUMBERYARD }
trees =  ground.flatten.count { |chr| chr == TREES }

puts "Lumberyards: #{lumberyards}"
puts "Trees: #{trees}"
puts "Score: #{lumberyards * trees}"
