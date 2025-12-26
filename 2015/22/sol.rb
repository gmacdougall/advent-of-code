#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'

class Character
  attr_accessor :hp, :mana, :armour
  attr_reader :effects

  def initialize
    @effects = []
    @armour = 0
    @mana = 0
  end

  def dead? = @hp <= 0

  def do_dmg(amount)
    @hp -= amount
  end
end

class Boss < Character
  def initialize
    super
    @hp, @dmg = File.read('input').scan(/\d+/).map(&:to_i)
    @poison_turns = 0
  end

  attr_accessor :poison_turns

  def go(opponent) = opponent.do_dmg(@dmg - opponent.armour)

  def apply_effects
    return unless @poison_turns.positive?

    @hp -= 3
    @poison_turns -= 1
  end

  def inspect = "<Boss hp=#{@hp}>"
end

class Player < Character
  def initialize
    super
    @hp = 50
    @mana = 500
    @armour = 0
    @shield_turns = 0
    @recharge_turns = 0
  end

  attr_reader :shield_turns, :recharge_turns

  COST = {
    magic_missiles: 53,
    drain: 73,
    shield: 113,
    poison: 173,
    recharge: 229
  }.freeze

  def inspect = "<Player hp=#{@hp} mana=#{@mana} armour=#{@armour}>"
  def armour = @shield_turns.positive? ? 7 : 0

  def valid_actions(opponent)
    [
      :magic_missiles,
      :drain,
      @shield_turns.zero? ? :shield : nil,
      @recharge_turns.zero? ? :recharge : nil,
      opponent.poison_turns.zero? ? :poison : nil
    ].compact.select { @mana >= COST[it] }
  end

  def magic_missiles(opponent)
    @mana -= COST[:magic_missiles]
    opponent.do_dmg(4)
  end

  def drain(opponent)
    @mana -= COST[:drain]
    @hp += 2
    opponent.do_dmg(2)
  end

  def shield(_)
    @mana -= COST[:shield]
    @shield_turns = 6
  end

  def recharge(_)
    @mana -= COST[:recharge]
    @recharge_turns = 5
  end

  def poison(opponent)
    @mana -= COST[:poison]
    opponent.poison_turns = 6
  end

  def apply_effects
    @shield_turns -= 1 if @shield_turns.positive?

    return unless @recharge_turns.positive?

    @mana += 101
    @recharge_turns -= 1
  end
end

class ActionChain
  def initialize(mana_spent, current_action, player, boss)
    @mana_spent = mana_spent
    @current_action = current_action
    @player = player
    @boss = boss
  end

  attr_reader :mana_spent, :current_action, :player, :boss
end

def solve(hp_change: false)
  player = Player.new
  boss = Boss.new

  action = ActionChain.new(0, nil, player, boss)
  pq = PQueue.new([action]) { |a, b| a.mana_spent < b.mana_spent }

  while (action_chain = pq.pop)
    player = action_chain.player
    boss = action_chain.boss

    action = action_chain.current_action
    if action
      player.hp = (player.hp - 1) if hp_change
      next if player.dead?

      player.public_send(action, boss)
      return action_chain.mana_spent if boss.dead?

      player.apply_effects
      boss.apply_effects
      return action_chain.mana_spent if boss.dead?

      boss.go(player)
      next if player.dead?

      player.apply_effects
      boss.apply_effects
      return action_chain.mana_spent if boss.dead?
    end

    action_chain.player.valid_actions(boss).each do |action|
      pq << ActionChain.new(
        action_chain.mana_spent + Player::COST[action],
        action,
        player.dup,
        boss.dup
      )
    end
  end
end

def part1 = solve
def part2 = solve(hp_change: true)

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
