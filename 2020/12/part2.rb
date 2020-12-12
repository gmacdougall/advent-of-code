#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.lines.map(&:strip)

class Ship
  attr_reader :x, :y, :x_waypoint, :y_waypoint

  def initialize(x_waypoint, y_waypoint)
    @x = 0
    @y = 0
    @x_waypoint = x_waypoint
    @y_waypoint = y_waypoint
  end

  def theta
    Math.atan2(@y_waypoint, @x_waypoint)
  end

  def vel
    Math.sqrt(@x_waypoint**2 + @y_waypoint**2)
  end

  def rotate(rad)
    update_waypoints(
      Math.cos(theta + rad) * vel,
      Math.sin(theta + rad) * vel
    )
  end

  def update_waypoints(x, y)
    @x_waypoint = x.round
    @y_waypoint = y.round
  end

  def go(instruction, num)
    case instruction
    when 'N'
      @y_waypoint += num
    when 'S'
      @y_waypoint -= num
    when 'E'
      @x_waypoint += num
    when 'W'
      @x_waypoint -= num
    when 'L'
      rotate(num * Math::PI / 180)
    when 'R'
      rotate(-num * Math::PI / 180)
    when 'F'
      @x += @x_waypoint * num
      @y += @y_waypoint * num
    end
  end

  def distance
    x.abs + y.abs
  end
end

ship = Ship.new(10, 1)

input.each do |line|
  instruction = line[0]
  num = line[1..-1].to_i
  ship.go(instruction, num)
end

puts ship.distance
