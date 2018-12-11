#!/usr/bin/env ruby

class Point
  attr_reader :x, :y
  def initialize(x, y, dx, dy)
    @x = x
    @y = y
    @dx = dx
    @dy = dy
  end

  def at(x, y)
    @x == x && @y == y
  end

  def move
    @x += @dx
    @y += @dy
  end
end

points = ARGF.map do |line|
  Point.new(*line.gsub('position=', '').gsub('velocity=', '').gsub('<', '').gsub('>', '').gsub(',', ' ').split(' ').map(&:to_i))
end

10_116.times { points.each(&:move) }

points.each(&:move)
x_values = points.map(&:x)
y_values = points.map(&:y)

(y_values.min..y_values.max).each do |y|
  row = []
  (x_values.min..x_values.max).each do |x|
    if points.any? { |point| point.at(x, y) }
      row << '#'
    else
      row << '.'
    end
  end
  puts row.join(' ')
end
