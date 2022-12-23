#! /usr/bin/env ruby
# frozen_string_literal: treu

$direction = {
  up: [0, -1],
  down: [0, 1],
  left: [-1, 0],
  right: [1, 0],
}

class Node
  attr_reader :x, :y, :proposed

  def initialize(x, y)
    @x = x
    @y = y
    self.class.nodes[[x, y]] = self
  end

  def self.find(x, y)
    nodes[[x, y]]
  end

  def self.nodes
    @nodes ||= {}
  end

  def propose_move
    @proposed = nil
    if any_adjacent?
      $direction.each do |dir, (dx, dy)|
        if !public_send(dir)
          @proposed = [x + dx, y + dy] 
          return @proposed
        end
      end
    end
    nil
  end

  def perform_proposed_move
    self.class.nodes.delete [x, y]
    @x, @y = @proposed
    self.class.nodes[[x, y]] = self
  end

  def any_adjacent?
    north || northwest || northeast || south || southwest || southeast || west || east
  end

  def up
    north || northwest || northeast
  end

  def down
    south || southwest || southeast
  end

  def left
    west || northwest || southwest
  end

  def right
    east || northeast || southeast
  end

  def north
    self.class.find(x, y - 1)
  end

  def south
    self.class.find(x, y + 1)
  end

  def west
    self.class.find(x - 1, y)
  end

  def east
    self.class.find(x + 1, y)
  end

  def northwest
    self.class.find(x - 1, y - 1)
  end

  def northeast
    self.class.find(x + 1, y - 1)
  end

  def southwest
    self.class.find(x - 1, y + 1)
  end

  def southeast
    self.class.find(x + 1, y + 1)
  end
end

input = ARGF.map(&:strip).map(&:chars)
input.each_with_index do |row, y|
  row.each_with_index do |chr, x|
    Node.new(x, y) if chr == '#'
  end
end

(1..).each do |n|
  moves = Node.nodes.values.map(&:propose_move).tally
  if moves.size == 1
    puts "Part 2: #{n}"
    exit
  end
  Node.nodes.values.each do |node|
    node.perform_proposed_move if node.proposed && moves[node.proposed] == 1
  end
  $direction = $direction.to_a.rotate.to_h

  if n == 10
    x_size = Node.nodes.values.map(&:x).minmax.inject(:-).abs + 1
    y_size = Node.nodes.values.map(&:y).minmax.inject(:-).abs + 1

    puts "Part 1: #{x_size * y_size - Node.nodes.size}"
  end
end
