#!/usr/bin/env ruby

input = File.read(ARGV.fetch(0)).strip.split("\n").map(&:chars)

class Tile
  attr_reader :x, :y, :level
  attr_accessor :bug

  def initialize(x, y, level, start)
    fail if x == 2 && y == 2
    @x = x
    @y = y
    @level = level
    @@all ||= {}
    @@all[[x, y, level]] = self
    @@history = []
    @bug = start
  end

  def self.all
    @@all
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
    (-5..5).each do |level|
      5.times do |y|
        5.times do |x|
          t = @@all[[x, y, level]]
          if t.nil?
            print '?'
          else
            print t
          end
        end
        puts
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
    if @y == 0
      @@all[[2, 1, @level - 1]]
    elsif @y == 3 && @x == 2
      @@all.values.select { |t| t.level == level + 1 && t.y == 4 }
    else
      @@all[[@x, @y - 1, @level]]
    end
  end

  def down
    if @y == 4
      @@all[[2, 3, @level - 1]]
    elsif @y == 1 && @x == 2
      @@all.values.select { |t| t.level == level + 1 && t.y == 0 }
    else
      @@all[[@x, @y + 1, @level]]
    end
  end

  def left
    if @x == 0
      @@all[[1, 2, @level - 1]]
    elsif @y == 2 && @x == 3
      @@all.values.select { |t| t.level == level + 1 && t.x == 4 }
    else
      @@all[[@x - 1, @y, @level]]
    end
  end

  def right
    if @x == 4
      @@all[[3, 2, @level - 1]]
    elsif @y == 2 && @x == 1
      @@all.values.select { |t| t.level == level + 1 && t.x == 0 }
    else
      @@all[[@x + 1, @y, @level]]
    end
  end

  def adjacent
    [up, down, left, right].flatten.compact
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
    next if x == 2 && y == 2
    Tile.new(x, y, 0, chr == '#')
  end
end

(-200..200).each do |level|
  next if level == 0
  5.times do |x|
    5.times do |y|
      next if x == 2 && y == 2
      Tile.new(x, y, level, false)
    end
  end
end

200.times { |n| Tile.tick }

puts Tile.bug_list.select { |v| v }.length
