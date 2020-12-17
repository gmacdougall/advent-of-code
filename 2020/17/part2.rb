#! /usr/bin/env ruby
# frozen_string_literal: true

ITERATIONS = 6

class Cube
  attr_reader :x, :y,:z, :w, :active

  @@all = {}

  def initialize(x, y, z, w, active = false)
    @x = x
    @y = y
    @z = z
    @w = w
    @active = active
    @@all[[w, x, y, z]] = self
  end

  def self.active_count
    @@all.values.count(&:active)
  end

  def self.find(x, y, z, w)
    @@all[[w, x, y, z]]
  end

  def self.find_or_create(x, y, z, w)
    find(x, y, z, w) || Cube.new(x, y, z, w)
  end

  def self.create_neighbours
    (-ITERATIONS...(ITERATIONS + SIZE)).each do |x|
      (-ITERATIONS...(ITERATIONS + SIZE)).each do |y|
        (-ITERATIONS..ITERATIONS).each do |z|
          (-ITERATIONS..ITERATIONS).each do |w|
            Cube.find_or_create(x, y, z, w)
          end
        end
      end
    end
  end

  def self.tick
    @@all.values.each(&:prepare)
    @@all.values.each(&:tick)
    puts '.'
  end

  def neighbours
    @neighbours ||= (-1..1).flat_map do |x|
      (-1..1).flat_map do |y|
        (-1..1).flat_map do |z|
          (-1..1).map do |w|
            Cube.find(@x + x, @y + y, @z + z, @w + w)
          end.reject { |c| c == self }.compact
        end
      end
    end
  end

  def prepare
    if active
      @next_active = (2..3).include?(neighbours.count(&:active))
    else
      @next_active = neighbours.count(&:active) == 3
    end
  end

  def tick
    @active = @next_active
    @next_active = nil
  end
end

input = ARGF.lines.map(&:strip)
SIZE = input.length

input.each_with_index do |line, y|
  line.chars.each_with_index do |chr, x|
    Cube.new(x, y, 0, 0, chr == '#')
  end
end

Cube.create_neighbours

puts Cube.active_count
6.times { Cube.tick }
puts Cube.active_count
