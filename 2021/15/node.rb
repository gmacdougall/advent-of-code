# frozen_string_literal: true

# Node represents a single point in the directed graph
class Node
  attr_reader :x, :y, :value
  attr_accessor :visited, :distance

  def initialize(x, y, value)
    @x = x
    @y = y
    @value = (value % 10) + (value / 10)
    @visited = false
    self.class.nodes[[x, y]] = self
  end

  def self.nodes
    @nodes ||= {}
  end

  def self.find(x, y)
    nodes[[x, y]]
  end

  def find(x, y)
    self.class.find(x, y)
  end

  def up
    find(x, y - 1)
  end

  def down
    find(x, y + 1)
  end

  def left
    find(x - 1, y)
  end

  def right
    find(x + 1, y)
  end

  def adjacent
    [up, down, left, right].compact
  end
end
