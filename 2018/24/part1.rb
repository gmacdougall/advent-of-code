#!/usr/bin/env ruby

class Unit
  include Comparable

  attr_reader :type,
    :num,
    :hp,
    :weaknesses,
    :immunities,
    :attack_type,
    :dmg,
    :initiative,
    :idx

  attr_accessor :targeted, :target

  def initialize(
    idx,
    type,
    num,
    hp,
    weaknesses,
    immunities,
    attack_type,
    dmg,
    initiative
  )
    @idx = idx
    @type = type
    @num = num
    @hp = hp
    @weaknesses = weaknesses
    @immunities = immunities
    @attack_type = attack_type
    @dmg = dmg
    @initiative = initiative
    reset
  end

  def reset
    @targeted = false
    @target = nil
  end

  def <=>(other)
    [effective_power, initiative] <=> [other.effective_power, other.initiative]
  end

  def valid_enemies
    $units.select { |unit| unit.type != type && !unit.targeted }
  end

  def calc_damage(unit)
    if unit.immunities.include?(attack_type)
      0
    elsif unit.weaknesses.include?(attack_type)
      effective_power * 2
    else
      effective_power
    end
  end

  def alive?
    num > 0
  end

  def dead?
    !alive?
  end

  def take_damage(amount)
    @num -= amount / hp
    @num = 0 if @num < 0
  end

  def choose_target
    max_damage = valid_enemies.map { |unit| calc_damage(unit) }.max
    if max_damage && max_damage > 0
      @target = valid_enemies.sort.reverse.detect { |unit| calc_damage(unit) == max_damage }
      puts "#{type} #{idx} chooses target #{target.type} #{target.idx} from #{valid_enemies.map(&:idx).join(', ')}"
      @target.targeted = true
    else
      puts "#{type} #{idx} can't damage any of #{valid_enemies.map(&:idx).join(', ')}"
    end
  end

  def attack
    if @target
      alive_before = target.num
      target.take_damage(calc_damage(target))
      alive_after = target.num
      puts "#{type} #{self.idx} attacks #{target.type} #{target.idx} for #{calc_damage(target)} - #{alive_before - alive_after} killed"
    end
  end

  def effective_power
    num * dmg
  end
end

$units = []
type = :immune
idx = 0

ARGF.each do |line|
  if line.start_with?('Infection')
    type = :infection
    idx = 0
  end

  result = line.match(/(\d+) units each with (\d+) hit points.*with an attack that does (\d+) (\S+) damage at initiative (\d+)/)

  next unless result
  idx += 1

  weaknesses = []
  immunities = []

  num = result[1].to_i
  hp = result[2].to_i
  dmg = result[3].to_i
  attack_type = result[4].to_sym
  initiative = result[5].to_i

  result = line.match(/weak to ([a-z, ]+)/)
  if result
    weaknesses = result[1].split(',').map(&:strip).map(&:to_sym)
  end

  result = line.match(/immune to ([a-z, ]+)/)
  if result
    immunities = result[1].split(',').map(&:strip).map(&:to_sym)
  end

  $units << Unit.new(
    idx,
    type,
    num,
    hp,
    weaknesses,
    immunities,
    attack_type,
    dmg,
    initiative
  )
end

while $units.select(&:alive?).map(&:type).uniq.count > 1
  puts "Immune System:"
  $units.select { |unit| unit.type == :immune }.each do |unit|
    puts "Group #{unit.idx} (Initiative: #{unit.initiative}) contains #{unit.num} units, does #{unit.dmg} #{unit.attack_type} dmg. Effective Power: #{unit.effective_power} (Weaknesses: #{unit.weaknesses.join(', ')}, Immunities: #{unit.immunities.join(', ')})"
  end

  puts "Infection:"
  $units.select { |unit| unit.type == :infection }.each do |unit|
    puts "Group #{unit.idx} (Initiative: #{unit.initiative}) contains #{unit.num} units, does #{unit.dmg} #{unit.attack_type} dmg. Effective Power: #{unit.effective_power} (Weaknesses: #{unit.weaknesses.join(', ')}, Immunities: #{unit.immunities.join(', ')})"
  end

  $units.each(&:reset)
  $units.sort.reverse.each(&:choose_target)
  $units.sort { |a, b| -a.initiative <=> -b.initiative }.each(&:attack)
  puts "\n\n"

  $units.reject!(&:dead?)
end

puts $units.map(&:num).sum
