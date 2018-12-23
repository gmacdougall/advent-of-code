#! /usr/bin/env ruby

class Bot
  attr_reader :x, :y, :z, :r

  def initialize(x, y, z, r)
    @x = x
    @y = y
    @z = z
    @r = r
  end

  def in_range?(bot)
    (x - bot.x).abs + (y - bot.y).abs + (z - bot.z).abs <= r
  end
end

bots = []

ARGF.each do |line|
  bots << Bot.new(
    *line.match(/pos=<(-?\d*),(-?\d*),(-?\d*)>, r=(\d*)/).to_a.last(4).map(&:to_i)
  )
end

strongest = bots.max { |a, b| a.r <=> b.r }

puts bots.count { |bot| strongest.in_range?(bot) }
