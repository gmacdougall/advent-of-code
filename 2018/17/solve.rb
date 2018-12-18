#!/usr/bin/env ruby

CLAY = '#'.freeze
SAND = '.'.freeze
WATER_FALLING = '|'.freeze
WATER_STANDING = '~'.freeze
WATER = [WATER_FALLING, WATER_STANDING].freeze

commands = ARGF.map do |line|
  result = []
  line.gsub(',', '').split(' ').each do |command|
    direction, number = command.split('=')
    if number.include?('..')
      split = number.split('..').map(&:to_i)
      number = (split.first..split.last)
    else
      number = [number.to_i]
    end

    if direction == 'x'
      result[0] = number
    else
      result[1] = number
    end
  end
  result
end

MIN_X = commands.map(&:first).map(&:to_a).flatten.min - 1
MAX_X = commands.map(&:first).map(&:to_a).flatten.max + 1
MIN_Y = commands.map(&:last).map(&:to_a).flatten.min
MAX_Y = commands.map(&:last).map(&:to_a).flatten.max
X_LEN = MAX_X - MIN_X + 1

ground = []

(0..MAX_Y + 1).each do |y|
  ground[y] = []
  (MIN_X..MAX_X).each do |x|
    ground[y][x] = SAND
  end
end

commands.each do |x_set, y_set|
  y_set.each do |y|
    x_set.each do |x|
      ground[y][x] = CLAY
    end
  end
end

def print(ground)
  (MIN_Y...MAX_Y).each do |y|
    puts ground[y].slice(MIN_X, X_LEN).join
  end
  puts "\n"
end

def path_of_escape(ground, x, y, dont_go = nil)
  return true if ground[y + 1][x] == SAND
  return true if ground[y][x + 1] == WATER_STANDING
  return true if ground[y][x - 1] == WATER_STANDING
  return false if ground[y][x] == CLAY
  (dont_go != :right && path_of_escape(ground, x + 1, y, :left)) ||
    (dont_go != :left && path_of_escape(ground, x - 1, y, :right))
end

def overflow(ground, x, y)
  left_most_clay = x
  while ground[y][left_most_clay] != CLAY
    return false if left_most_clay < MIN_X
    left_most_clay -= 1
  end

  right_most_clay = x
  while ground[y][right_most_clay] != CLAY
    return false if right_most_clay > MAX_X
    right_most_clay += 1
  end

  ground[y].slice(left_most_clay + 1, right_most_clay - left_most_clay - 1).all? { |chr| chr == WATER_FALLING }
end

def falling_water(ground, x, y)
  return if y > MAX_Y

  ground[y][x] = '|'
  if (ground[y + 1][x] == SAND)
    falling_water(ground, x, y + 1)
  elsif ground[y + 1][x] == CLAY
    if (ground[y][x + 1] != WATER_FALLING && ground[y][x - 1] != WATER_FALLING)
      standing_water(ground, x, y)
    else
      [x + 1, x - 1].each do |dx|
        if (ground[y][dx] == SAND)
          falling_water(ground, dx, y)
        end
      end
    end
  end

  if (ground[y + 1][x] == WATER_STANDING)
    if overflow(ground, x, y)
      standing_water(ground, x, y)
      falling_water(ground, x, y - 1)
    elsif (path_of_escape(ground, x, y))
      falling_water(ground, x + 1, y) if (ground[y][x + 1] == SAND)
      falling_water(ground, x - 1, y) if (ground[y][x - 1] == SAND)
    else
      standing_water(ground, x, y)
    end
  end
end

def standing_water(ground, x, y)
  ground[y][x] = '~'
  [x + 1, x - 1].each do |dx|
    if (ground[y][dx] == SAND || ground[y][dx] == WATER_FALLING)
      standing_water(ground, dx, y)
    end
  end

  if (ground[y + 1][x] == SAND)
    standing_water(ground, x, y + 1)
  end
end

falling_water(ground, 500, MIN_Y)

print(ground)

puts "Part 1: ", ground.flatten.compact.select { |point| point == WATER_FALLING || point == WATER_STANDING }.length
puts "Part 2: ", ground.flatten.compact.select { |point| point == WATER_STANDING }.length
