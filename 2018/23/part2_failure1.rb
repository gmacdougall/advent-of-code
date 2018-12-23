#! /usr/bin/env ruby

class Point
  attr_reader :x, :y, :z
  attr_accessor :in_range

  include Comparable

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
    @in_range = 0
  end

  def <=>(other)
    in_range <=> other.in_range
  end
end

class Bot < Point
  attr_reader :r

  def initialize(x, y, z, r)
    @r = r
    super(x, y, z)
  end

  def in_range?(point)
    (x - point.x).abs + (y - point.y).abs + (z - point.z).abs <= r
  end
end

bots = []

ARGF.each do |line|
  bots << Bot.new(
    *line.match(/pos=<(-?\d*),(-?\d*),(-?\d*)>, r=(\d*)/).to_a.last(4).map(&:to_i)
  )
end

x_range = Range.new(*bots.map(&:x).minmax)
y_range = Range.new(*bots.map(&:y).minmax)
z_range = Range.new(*bots.map(&:z).minmax)

points = []

loop do
  x_step = x_range.size / 13
  y_step = y_range.size / 13
  z_step = z_range.size / 13

  x_step = 1 if x_step == 0
  y_step = 1 if y_step == 0
  z_step = 1 if z_step == 0

  points = []
  x_range.step(x_step) do |x|
    y_range.step(y_step) do |y|
      z_range.step(z_step) do |z|
        point = Point.new(x ,y, z)
        bots.each do |bot|
          point.in_range += 1 if bot.in_range?(point)
        end
        points << point
      end
    end
  end

  break if [x_step, y_step, z_step].all? { |n| n == 1 }
  x_range = Range.new(points.max.x - x_step, points.max.x + x_step)
  y_range = Range.new(points.max.y - y_step, points.max.y + y_step)
  z_range = Range.new(points.max.z - z_step, points.max.z + z_step)
end

max = points.max

require 'pry'
binding.pry

puts max.x.abs + max.y.abs + max.z.abs
