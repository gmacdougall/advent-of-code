#!/usr/bin/env ruby

map = """
#########################################
#.........#.......#.................#...#
#.#.#####.#####.#.#.#############.#.#.#.#
#.#.....#.......#.#...#...#...#...#.#.#.#
#.#####.#.###########.#.#.#.#.#.#####.#.#
#...#...#.#.........#...#...#.#...#...#.#
###.#.###.#.#####.###########.###.#.###.#
#.#.#.#...#.#...#.........#.#...#.#...#.#
#.#.#.#.###.###.#######.#.#.###.#.###.#.#
#.#.#.#...#.....#.....#.#.....#.#...#.#.#
#.#.#.#.#######.###.###.#.#####.#.###.#.#
#.#.#.#.#...........#...#.#.....#.....#.#
#.#.#.###.###########.#####.###########.#
#...#...........#...#.#.......#.....#...#
#.#####.#########.#.#.#.#####.#.###.#.#.#
#.#...#.#.........#.#...#...#.#.#.....#.#
###.#.###.#########.#####.#.###.#.#####.#
#...#...........#...#.....#...#.#.#...#.#
#.#############.#.###.#######.#.###.#.###
#...#.#.......#.#.....#.......#.....#...#
###.#.#.#####.#########.###########.###.#
#.#...#...#...#.......#.....#.....#...#.#
#.###.###.#.###.###########.#.#.#.#####.#
#...#...#.#...#...#...#.....#.#.#.#...#.#
#.#.###.#.###.###.#.#.#.#######.#.#.#.#.#
#.#...#.#.#.#...#.#.#.#.#.......#.#.#.#.#
#.#####.#.#.###.#.#.#.#.#.#######.#.#.#.#
#.#.....#...#.#...#.#.#.#...#.......#...#
#.#.#######.#.#####.#.#.###.###########.#
#...#.....#.#...#...#.#.#...#.........#.#
#.###.###.#.#.#.#.#.#.#.#.#.#.#######.###
#.#.#.#...#.#.#.#.#.#...#.#.#.#.....#...#
#.#.#.#.###.#.#.#.#.#####.###.#####.###.#
#.#...#.#...#.#...#...#...#...#.....#...#
#.###.#.#.###########.#.#.#.###.#####.###
#...#O#.#.............#.#.#.....#...#...#
###.###.#################.#####.#.#.###.#
#.#...#...#.......#.....#.......#.#...#.#
#.###.#.#.###.###.#.###.#########.###.#.#
#.......#.....#.....#.............#.....#
#########################################
"""

grid = map.strip.split("\n").map(&:chars)

steps = 0
while grid.flatten.include?('.')
  steps += 1

  grid.each_with_index do |row, y|
    row.each_with_index do |point, x|
      if point == 'O'
        grid[y + 1][x] = '$' if grid[y + 1][x] == '.'
        grid[y - 1][x] = '$' if grid[y - 1][x] == '.'
        grid[y][x + 1] = '$' if grid[y][x + 1] == '.'
        grid[y][x - 1] = '$' if grid[y][x - 1] == '.'
      end
    end
  end

  grid.each_with_index do |row, y|
    row.each_with_index do |point, x|
      grid[y][x] = 'O' if point == '$'
    end
  end
end

puts steps
