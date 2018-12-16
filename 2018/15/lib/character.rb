class Character
  attr_reader :type, :hp, :tile, :declared_victory

  include Comparable

  def initialize(map, type, tile)
    @map = map
    @type = type
    @hp = 200
    @tile = tile
    @declared_victory = false
  end

  def <=>(other)
    tile <=> other.tile
  end

  def damage
    @hp -= 3

    @map.kill(self) if dead?
  end

  def take_action
    return if dead?
    @declared_victory = true if enemies.none?

    if targets_in_range.none? && tile = best_target_tile
      move_towards(tile)
    end

    if targets_in_range.any?
      attack
    end
  end

  def valid_attack_tiles
    @tile.available_adjacent
  end

  def to_s
    "#{@type}(#{@hp})"
  end

  private

  def enemies
    @map.enemies(@type)
  end

  def dead?
    @hp <= 0
  end

  def targets_in_range
    enemies.select { |enemy| @tile.adjacent.include?(enemy.tile) }
  end

  def attack
    weakest = targets_in_range.map(&:hp).min
    targets_in_range.sort.detect { |enemy| enemy.hp == weakest }.damage
  end

  def move_towards(tile)
    shortest_distance = tile.distance
    %i[up left right down].each do |direction|
      next unless first_move = @tile.public_send(direction)
      next unless first_move.empty?
      first_move.compute_distance
      next unless tile.distance == shortest_distance - 1

      @tile = first_move
      return
    end
  end

  def best_target_tile
    result = enemies.flat_map do |enemy|
      enemy.valid_attack_tiles
    end
    @tile.compute_distance
    min_distance = result.map(&:distance).min

    if min_distance && min_distance < Float::INFINITY
      result.detect { |tile| tile.distance == min_distance }
    end
  end
end
