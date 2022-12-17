#! /usr/bin/env ruby

movement = ARGF.first.strip.chars

SHAPES = {
  horizontal: "|..@@@@.|",
  plus: "|...@...| |..@@@..| |...@...|",
  l: "|....@..| |....@..| |..@@@..|",
  vertical: "|..@....| |..@....| |..@....| |..@....|",
  square: "|..@@...| |..@@...|",
}.transform_values { _1.gsub(' ', '').gsub('|', '').chars.map { |c| c == '@' ? true : nil }.each_slice(7).to_a.reverse }

grid = []

def output(grid)
  grid.reverse.each do |line|
    puts line.map { _1.nil? ? '.' : '#' }.join
  end
end

last_1000_lines = []
height = []

(0..).each do |n|
  while grid.last(3).length != 3 || grid.last(3).flatten.compact.any?
    grid.push Array.new(7)
  end

  shape_position = grid.length
  shape = SHAPES.values[n % SHAPES.length].map(&:dup)

  loop do
    to_add = shape.map(&:dup)

    dir = 1
    dir = -1 if (movement.first == '>')
    movement.rotate!

    unless shape.map { dir == 1 ? _1.first : _1.last }.any?
      shape.each { _1.rotate!(dir) }
      if grid[shape_position]&.each_with_index&.any? { |val, idx| val && shape[0][idx] } ||
        (shape[1] && grid[shape_position + 1]&.each_with_index&.any? { |val, idx| val && shape[1][idx] }) ||
        (shape[2] && grid[shape_position + 2]&.each_with_index&.any? { |val, idx| val && shape[2][idx] }) ||
        (shape[3] && grid[shape_position + 3]&.each_with_index&.any? { |val, idx| val && shape[3][idx] })
        # collission: rotate back
        shape.each { _1.rotate!(-dir) }
      end
    end

    break if shape_position == 0
    break if grid[shape_position - 1].each_with_index.any? { |val, idx| shape[0][idx] && val }
    break if shape[1] && grid[shape_position] && grid[shape_position].each_with_index.any? { |val, idx| shape[1][idx] && val }
    shape_position -= 1
  end

  shape.each do |row|
    grid[shape_position] ||= Array.new(7)
    grid[shape_position].each_with_index do |val, idx|
      grid[shape_position][idx] = val || row[idx]
    end
    shape_position += 1
  end

  h = grid.last(1000).hash
  current_height = grid.reject { _1.all?(&:nil?) }.size
  if last_1000_lines.include?(h)
    puts "Cycle found"
    big_number = 1_000_000_000_000
    cycle_start_index = last_1000_lines.find_index(h)
    cycle_size = n - cycle_start_index
    height_added_per_cycle = current_height  - height[cycle_start_index]

    full_cycles_to_add = (big_number - n) / cycle_size
    additional_top_up_needed = big_number - (n + full_cycles_to_add * cycle_size)
    top_up_height = height[cycle_start_index + additional_top_up_needed] - height[cycle_start_index]

    # I don't know why I need - 1. I have a big off by one error
    puts current_height + height_added_per_cycle * full_cycles_to_add  + top_up_height - 1
    exit
  else
    last_1000_lines << h
    height << current_height
  end
end

puts grid.reject { _1.all?(&:nil?) }.size
