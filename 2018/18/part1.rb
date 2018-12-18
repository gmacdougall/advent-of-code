#!/usr/bin/env ruby

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

MAX_X = ground.first.length - 1
MAX_Y = ground.length - 1

10.times do
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
  print ground
end

lumberyards =  ground.flatten.count { |chr| chr == LUMBERYARD }
trees =  ground.flatten.count { |chr| chr == TREES }

puts "Lumberyards: #{lumberyards}"
puts "Trees: #{trees}"
puts "Score: #{lumberyards * trees}"
