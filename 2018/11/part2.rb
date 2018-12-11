#!/usr/bin/env ruby

SERIAL_NUMBER = 5153

$cells = {}

class Cell
  def initialize(x, y)
    @x = x
    @y = y
  end

  def rack_id
    @x + 10
  end

  def power_level
    @power_level ||= (((((rack_id * @y) + SERIAL_NUMBER) * rack_id) / 100) % 10) - 5
  end

  def grid_power(size)
    size.times.flat_map do |x|
      size.times.flat_map do |y|
        $cells[:"#{@x + x}-#{@y + y}"]&.power_level || 0
      end
    end.sum
  end
end

(0..300).flat_map do |x|
  (0..300).flat_map do |y|
    $cells[:"#{x}-#{y}"] = Cell.new(x, y)
  end
end

(2..30).each do |n|
  puts n
  cell = $cells.max_by { |_,v| v.grid_power(n) }
  puts cell.first
  puts cell.last.grid_power(n)
end
