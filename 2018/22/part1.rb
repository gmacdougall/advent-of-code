#! /usr/bin/env ruby

DEPTH = 5913
TARGET = [8, 701]

$index_cache = {}

def geologic_index(x, y)
  if $index_cache["#{x}-#{y}"].nil?
    result = if x == 0 && y == 0
      0
    elsif TARGET.first == x && TARGET.last == y
      0
    elsif y == 0
      x * 16807
    elsif x == 0
      y * 48271
    else
      geologic_index(x - 1, y) * geologic_index(x, y - 1)
    end
    $index_cache["#{x}-#{y}"] = (result + DEPTH) % 20183
  end
  $index_cache["#{x}-#{y}"]
end

def type(index)
  index % 3
end

result = (0..TARGET.first).flat_map do |x|
  (0..TARGET.last).map do |y|
    type(geologic_index(x, y))
  end
end

puts result.sum
