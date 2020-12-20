#! /usr/bin/env ruby
# frozen_string_literal: true

class Tile
  attr_reader :num, :contents

  def initialize(num, contents)
    @num = num.sub('Tile ', '').to_i
    @contents = contents
  end

  def others
    TILES.reject { |t| t == self }
  end

  def edges
    @edges ||= [
      @contents.first,
      @contents.last,
      @contents.map { |c| c[0] }.join,
      @contents.map { |c| c[-1] }.join,
    ]
  end

  def edge_permutations
    @edge_permutations ||= edges + edges.map(&:reverse)
  end

  def edge_matches
    edges.map do |edge|
      others.count { |other_tile| other_tile.edge_permutations.include?(edge) }
    end
  end
end

TILES = ARGF.read.split("\n\n").map do |s|
  a = s.split("\n")

  Tile.new(a.shift, a)
end

corners = TILES.select do |tile|
  tile.edge_matches.count(&:zero?) == 2
end

p corners.map(&:num).inject(:*)
