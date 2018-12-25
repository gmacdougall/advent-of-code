#!/usr/bin/env ruby

class Point
  attr_reader :a, :b, :c, :d

  attr_accessor :group

  def initialize(a, b, c, d)
    @a = a
    @b = b
    @c = c
    @d = d
  end

  def distance_to(point)
    (point.a - a).abs + (point.b - b).abs + (point.c - c).abs + (point.d - d).abs
  end

  def within_three
    $points.select do |point|
      distance_to(point) <= 3
    end
  end

  def assign_to_group(num)
    @group = num
    within_three.each do |p|
      p.assign_to_group(num) unless p.group
    end
  end
end

$points = []
ARGF.each do |line|
  $points << Point.new(*line.strip.split(',').map(&:to_i))
end

group = 0
while $points.any? { |p| p.group.nil? }
  $points.reject(&:group).first.assign_to_group(group)
  group += 1
end

puts group
