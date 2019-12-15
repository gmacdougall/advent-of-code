#!/usr/bin/env ruby

require 'set'

class Moon
  attr_reader :x, :y, :z, :vel_x, :vel_y, :vel_z

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z

    @vel_x = 0
    @vel_y = 0
    @vel_z = 0

    @history = {
      x: [x],
      y: [y],
      z: [z],
    }
    @period = {
      x: nil,
      y: nil,
      z: nil
    }
  end

  def period
    @period.values.reduce(1, :lcm)
  end

  def change_velocity(target)
    if target.x > x
      @vel_x += 1
    elsif target.x < x
      @vel_x -= 1
    end

    if target.y > y
      @vel_y += 1
    elsif target.y < y
      @vel_y -= 1
    end

    if target.z > z
      @vel_z += 1
    elsif target.z < z
      @vel_z -= 1
    end
  end

  def apply_velocity
    @x += vel_x
    @y += vel_y
    @z += vel_z

    @history[:x] << x
    @history[:y] << y
    @history[:z] << z

    check_period
  end

  def vars
    [@x, @y, @z, @vel_x, @vel_y, @vel_z]
  end

  def energy
    (@x.abs + @y.abs + @z.abs) * (@vel_x.abs + @vel_y.abs + @vel_z.abs)
  end

  def to_s
    "pos=<x=#{x.to_s.rjust(3)}, y=#{y.to_s.rjust(3)}, z=#{z.to_s.rjust(3)}>, " \
      "vel=<#{vel_x.to_s.rjust(3)}, y=#{vel_y.to_s.rjust(3)}, z=#{vel_z.to_s.rjust(3)}>"
  end

  def still_searching?
    @period.values.any?(&:nil?)
  end

  private

  def check_period
    %i[x y z].each do |var|
      a = @history[var]
      next unless @period[var].nil? && a.length % 2 == 0

      iterations = a.length / 2

      success = true
      iterations.times do |n|
        if a[n] != a[iterations + n]
          success = false
          break
        end
      end

      if success
        @period[var] = a.length / 2
      end
    end
  end
end

moons = File.read(ARGV.fetch(0)).strip.split("\n").map do |s|
  h = Hash[
    s.gsub('<', '').split(' ').map do |p|
      p.split('=').tap { |x| x[-1] = x.last.to_i }
    end
  ]
  Moon.new(h['x'], h['y'], h['z'])
end

def output(moons, step)
  puts "After #{step} steps"
  moons.each { |m| puts m }
end

step = 0

while moons.any?(&:still_searching?)
  step += 1
  moons.permutation(2).each do |source, target|
    source.change_velocity(target)
  end
  moons.each(&:apply_velocity)
end

puts moons.map(&:period).reduce(1, :lcm)
