require_relative 'character'
require_relative 'tile'

class Map
  attr_reader :characters, :round

  def initialize
    @tiles = []
    @characters = []
    @round = 0
  end

  def self.parse(string)
    map = new
    string.split("\n").each_with_index do |row, y|
      row.split('').each_with_index do |chr, x|
        unless chr == '#'
          tile = Tile.new(map, x, y)

          if chr == 'G' || chr == 'E'
            map.add_character Character.new(map, chr, tile)
          end

          map << tile
        end
      end
    end
    map
  end

  def all_tiles
    @tiles.flatten.compact
  end

  def dig(x, y)
    @tiles.dig(y, x)
  end

  def add_character(character)
    @characters << character
  end

  def victory?
    @characters.any?(&:declared_victory)
  end

  def total_hp
    @characters.sum(&:hp)
  end

  def score
    @round * total_hp
  end

  def kill(character)
    @characters.delete(character)
  end

  def <<(tile)
    @tiles[tile.y] ||= []
    @tiles[tile.y][tile.x] = tile
  end

  def take_actions
    @characters.sort.each(&:take_action)
    @round += 1 unless victory?
  end

  def enemies(type)
    @characters.select { |character| character.type != type }
  end

  def to_s
    result = (@tiles.flatten.compact.map(&:y).max + 2).times.map do |y|
      characters_on_line = []
      portion = (@tiles.flatten.compact.map(&:x).max + 2).times.map do |x|
        if @tiles[y].nil? || @tiles[y][x].nil?
          '#'
        else
          tile = @tiles[y][x]
          if c = @characters.detect { |char| char.tile == tile }
            characters_on_line << c
            c.type
          else
            '.'
          end
        end
      end.join

      if characters_on_line.any?
        portion += '   '
        portion += characters_on_line.join(', ')
      end
      portion
    end
    result.join("\n") + "\n"
  end
end
