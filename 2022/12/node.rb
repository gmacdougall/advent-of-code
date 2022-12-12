# frozen_string_literal: true

# Node represents a single point in the directed graph
class Node
  attr_reader :x, :y, :value, :finish
  attr_accessor :visited, :distance

  def initialize(x, y, value)
    @x = x
    @y = y
    @start = false
    @finish = false
    if value == 'S'
      @start = true
      @value = 'a'.ord
    elsif value == 'E'
      @finish = true
      @value = 'z'.ord
    else
      @value = value.ord 
    end
    @visited = false
    self.class.nodes[[x, y]] = self
  end

  def self.start
    @nodes.values.find(&:start?)
  end

  def self.finish
    @nodes.values.find(&:finish?)
  end

  def start?
    @start
  end

  def finish?
    @finish
  end

  def self.reset
    @nodes.values.each do |node|
      node.visited = false
      node.distance = nil
    end
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
    [up, down, left, right].compact.reject { _1.value > @value + 1}
  end
end
