#!/usr/bin/env ruby

map = File.read(ARGV.fetch(0)).strip.split("\n").map(&:chars)

result = map.each_with_index.map do |row, y|
  next if y == 0 || y == map.length - 1
  row.each_with_index.map do |chr, x|
    adjacent = [
      map[y + 1][x],
      map[y - 1][x],
      map[y][x + 1],
      map[y][x - 1],
    ]
    if chr == '#' && adjacent.all? { |c| c == '#' }
      x * y
    end
  end
end

puts result.flatten.compact.sum
