#!/usr/bin/env ruby

input = File.read(ARGV.fetch(0)).strip.split("\n").map(&:chars)

class Tile
  attr_accessor :bug

  def initialize(x, y, start)
    @x = x
    @y = y
    @@all ||= {}
    @@all[[x, y]] = self
    @@history = []
    @bug = start
  end

  def self.biodiversity
    @@all.values.each_with_index.map do |tile, idx|
      if tile.bug?
        2 ** idx
      else
        0
      end
    end.sum
  end

  def self.bug_list
    @@all.values.map(&:bug?)
  end

  def self.tick
    @@all.values.each(&:ready)
    @@all.values.each(&:tick)
  end

  def self.draw
    5.times do |y|
      5.times do |x|
        print @@all[[x, y]].to_s
      end
      puts
    end
    puts
  end

  def to_s
    bug? ? '#' : '.'
  end

  def bug?
    @bug
  end

  def up
    @@all[[@x, @y - 1]]
  end

  def down
    @@all[[@x, @y + 1]]
  end

  def left
    @@all[[@x - 1, @y]]
  end

  def right
    @@all[[@x + 1, @y]]
  end

  def adjacent
    [up, down, left, right].compact
  end

  def tick
    @bug = @next
  end

  def adjacent_bugs
    adjacent.select(&:bug?).length
  end

  def ready
    @next = @bug
    if @bug
      @next = false unless adjacent_bugs == 1
    else
      @next = true if [1, 2].include?(adjacent_bugs)
    end
  end
end

input.each_with_index do |row, y|
  row.each_with_index do |chr, x|
    Tile.new(x, y, chr == '#')
  end
end

history = []
duplicate = false
while !duplicate
  Tile.tick
  list = Tile.bug_list
  duplicate = true if history.include?(list)
  history << list
end

puts Tile.biodiversity
