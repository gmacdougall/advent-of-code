class Tile
  include Comparable

  attr_accessor :visited, :distance
  attr_reader :x, :y

  def initialize(map, x, y)
    @map = map
    @x = x
    @y = y
  end

  def <=>(other)
    [y, x] <=> [other.y, other.x]
  end

  def empty?
    @map.characters.none? { |c| c.tile.eql?(self) }
  end

  def compute_distance
    unvisited = @map.all_tiles.map do |tile|
      tile.visited = false
      tile.distance = Float::INFINITY
      tile
    end

    self.distance = 0

    while unvisited.any? { |node| node.distance != Float::INFINITY }
      minimum_distance = unvisited.map(&:distance).min
      current = unvisited.detect { |node| node.distance == minimum_distance }

      current.available_adjacent.each do |tile|
        if tile.distance > current.distance + 1
          tile.distance = current.distance + 1
        end
      end

      current.visited = true
      unvisited.delete(current)
    end
  end

  def adjacent
    [up, left, right, down].compact
  end

  def available_adjacent
    adjacent.select(&:empty?)
  end

  def up
    read_map(x, y - 1)
  end

  def left
    read_map(x - 1, y)
  end

  def right
    read_map(x + 1, y)
  end

  def down
    read_map(x, y + 1)
  end

  def inspect
    "Tile(#{x},#{y})"
  end

  private

  def read_map(x, y)
    tile = @map.dig(x, y)
    tile = nil unless tile.is_a?(Tile)
    tile
  end
end
