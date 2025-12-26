#! /usr/bin/env ruby
# frozen_string_literal: true

def items
  File.read('items').split("\n\n").map do |line|
    line.lines[1..].map do |item|
      name, cost, dmg, armour = item.split(/\s{2,}/)
      {
        name:,
        cost: cost.to_i,
        dmg: dmg.to_i,
        armour: armour.to_i
      }
    end
  end
end

def fight(items, monster)
  combatants = [
    {
      name: 'self',
      hp: 100,
      dmg: items.sum { it[:dmg] },
      armour: items.sum { it[:armour] }
    },
    {
      name: 'monster',
      hp: monster[0],
      dmg: monster[1],
      armour: monster[2]
    }
  ]

  while combatants.all? { it[:hp].positive? }
    dmg = (combatants.first[:dmg] - combatants.last[:armour]).clamp(1..)
    combatants.last[:hp] -= dmg
    combatants.rotate!
  end

  combatants.find { it[:hp].positive? }[:name]
end

def winners(target)
  weapons, armour, rings = items
  armour.push(nil)

  item_combos = weapons.product(armour).product([nil] + rings.combination(1).to_a + rings.combination(2).to_a).map do
    it.flatten.compact
  end
  item_combos.select { |items| fight(items, [109, 8, 2]) == target }
end

def part1
  winners('self').map { |set| set.sum { it[:cost] } }.min
end

def part2
  winners('monster').map { |set| set.sum { it[:cost] } }.max
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
