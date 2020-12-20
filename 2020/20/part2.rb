#! /usr/bin/env ruby
# frozen_string_literal: true

class Tile
  attr_reader :num, :contents

  def initialize(num, contents)
    @num = num.sub('Tile ', '').to_i
    @contents = contents
  end

  def self.find(num)
    TILES.find { |t| t.num == num }
  end

  def trimmed_contents
    @contents[1...-1].map { |a| a[1...-1] }
  end

  def others
    TILES.reject { |t| t == self }
  end

  def top
    @contents.first
  end

  def right
    @contents.map(&:last)
  end

  def bottom
    @contents.last
  end

  def left
    @contents.map(&:first)
  end

  def rotate
    @contents = @contents.reverse.transpose
  end

  def flip
    @contents = @contents.reverse
  end

  def edges
    [top, right, bottom, left]
  end

  def edge_permutations
    edges + edges.map(&:reverse)
  end

  def edge_matches
    edges.map do |edge|
      others.select { |other_tile| other_tile.edge_permutations.include?(edge) }
    end
  end

  def exact_edge_matches
    edges.map do |edge|
      others.select { |other_tile| other_tile.edges.include?(edge) }
    end
  end

  def potential_tile_right
    edge_matches[1].first
  end

  def potential_tile_down
    edge_matches[2].first
  end

  def tile_up
    exact_edge_matches[0].first
  end

  def tile_right
    exact_edge_matches[1].first
  end

  def tile_down
    exact_edge_matches[2].first
  end

  def tile_left
    exact_edge_matches[3].first
  end

  def correct_rotation(previous_tile, direction)
    2.times do
      4.times do
        return if public_send(direction) == previous_tile
        rotate
      end
      flip
    end
  end

  def inspect
    "<Tile:#{num}>"
  end
end

TILES = ARGF.read.split("\n\n").map do |s|
  a = s.split("\n")

  Tile.new(a.shift, a.map(&:chars))
end
# FIXME: This isn't 100%, but it works for my output
TILES.each(&:flip)
SIZE = Math.sqrt(TILES.length).round

start_corner = TILES.find do |tile|
  tile.edge_matches.count(&:empty?) == 2
end

while start_corner.edge_matches.first.any? || start_corner.edge_matches.last.any?
  start_corner.rotate
end

tile = start_corner
loop do
  start = tile
  (SIZE - 1).times do
    tile.potential_tile_right.correct_rotation(tile, :tile_left)
    tile = tile.tile_right
    print '.'
  end
  puts '$'
  break unless start.potential_tile_down
  start.potential_tile_down.correct_rotation(start, :tile_up)
  tile = start.tile_down
end

image = []
idx = 0

tile = start_corner
SIZE.times do
  row = tile
  SIZE.times do
    8.times do |n|
      image[idx + n] ||= ""
      image[idx + n] += tile.trimmed_contents[n].join
    end
    tile = tile.tile_right
  end
  idx += 8
  row = row.tile_down
  tile = row
end

SEA_MONSTER = File.read('sea_monster').split("\n")

count = 0
image.each_with_index do |row, y|
  row.chars.each_with_index do |_, x|
    found = true
    SEA_MONSTER.each_with_index do |sm_row, sm_y|
      sm_row.chars.each_with_index do |sm_chr, sm_x|
        found = false if sm_chr == '#' && image.fetch(y + sm_y, [])[x + sm_x] != '#'
      end
    end
    count += 1 if found
  end
end

p(
  image.join.count('#') - count * (SEA_MONSTER.join.count('#'))
)
