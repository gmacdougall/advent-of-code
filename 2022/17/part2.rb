#! /usr/bin/env ruby

movement = ARGF.first.strip.chars

WIDTH = 7

SHAPES = {
  horizontal: "|..@@@@.|",
  plus: "|...@...| |..@@@..| |...@...|",
  l: "|....@..| |....@..| |..@@@..|",
  vertical: "|..@....| |..@....| |..@....| |..@....|",
  square: "|..@@...| |..@@...|",
}.transform_values do |v|
  v.
    gsub(/[^\.@]/, '').
    chars.
    map { _1 == '@' }.
    each_slice(WIDTH).
    to_a.
    reverse
end.freeze

GRID = []

def output
  GRID.reverse.each { |line| puts line.map { _1 ? '.' : '#' }.join }
end

def collision?(shape, position)
  shape.length.times.any? do |offset|
    GRID[position + offset]&.zip(shape[offset])&.any? { _1 && _2 }
  end
end

def merge(shape, position)
  shape.each_with_index do |row, shape_idx|
    pos = position + shape_idx
    GRID[pos] ||= Array.new(WIDTH)
    GRID[pos].each_with_index { |val, idx| GRID[pos][idx] = val || row[idx] }
  end
end

last_1000_lines = []
height = []

(0..).each do |n|
  GRID.push Array.new(WIDTH) while GRID.length < 3 || GRID.last(3).any?(&:any?)

  shape_position = GRID.length
  shape = SHAPES.values[n % SHAPES.length].map(&:dup)

  loop do
    dir = movement.first == '>' ? -1 : 1
    movement.rotate!

    unless shape.map { dir == 1 ? _1.first : _1.last }.any?
      moved_shape = shape.map { _1.rotate(dir) }
      shape = moved_shape unless collision?(moved_shape, shape_position)
    end

    break if shape_position == 0 || collision?(shape, shape_position - 1)
    shape_position -= 1
  end

  merge(shape, shape_position)

  h = GRID.last(1000).hash
  current_height = GRID.rindex { !_1.all?(&:nil?) } + 1

  if last_1000_lines.include?(h)
    big_number = 1_000_000_000_000

    cycle_start_index = last_1000_lines.find_index(h)
    cycle_size = n - cycle_start_index
    height_added_per_cycle = current_height  - height[cycle_start_index]
    cycles_to_add = (big_number - cycle_start_index) / cycle_size

    result = height[big_number - (cycles_to_add * cycle_size) - 1] +
      cycles_to_add * height_added_per_cycle

    puts result
    exit
  else
    last_1000_lines << h
    height << current_height
  end
end
