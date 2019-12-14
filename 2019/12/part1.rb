#!/usr/bin/env ruby

class Moon
  attr_reader :x, :y, :z, :vel_x, :vel_y, :vel_z

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z

    @vel_x = 0
    @vel_y = 0
    @vel_z = 0
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
  end

  def energy
    (@x.abs + @y.abs + @z.abs) * (@vel_x.abs + @vel_y.abs + @vel_z.abs)
  end

  def to_s
    "pos=<x=#{x.to_s.rjust(3)}, y=#{y.to_s.rjust(3)}, z=#{z.to_s.rjust(3)}>, " \
      "vel=<#{vel_x.to_s.rjust(3)}, y=#{vel_y.to_s.rjust(3)}, z=#{vel_z.to_s.rjust(3)}>"
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
output(moons, step)

ARGV.fetch(1).to_i.times do
  step += 1
  moons.permutation(2).each do |source, target|
    source.change_velocity(target)
  end
  moons.each(&:apply_velocity)
  output(moons, step)
end

puts moons.sum(&:energy)
