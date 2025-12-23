#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def parse(fname)
  hash = { 'E' => 0 }
  File.read(fname).lines.each_with_index do |line, idx|
    chips = line.scan(/ (\w+)-compatible microchip/).map { "#{it[0][0].upcase}C" }
    generators = line.scan(/ (\w+) generator/).map { "#{it[0][0].upcase}G" }

    [chips, generators].flatten.each { hash[it] = idx }
  end
  hash
end

def valid?(map)
  (0..3).each do |level|
    on_level = map.select { _2 == level }.keys
    generators = on_level.select { it[1] == 'G' }
    chips = on_level.select { it[1] == 'C' }

    generators.each do |gen|
      chips.delete("#{gen[0]}C")
    end
    return false if generators.any? && chips.any?
  end
  true
end

def simplify(hash)
  (0..3).map { |n| hash.select { _2 == n }.keys.map { _1[-1] }.tally }
end

def part1(input)
  queue = [[input, 0, []]]
  visited = Set.new
  while queue.any?
    hash, distance, path = queue.shift

    simplified = simplify(hash)
    next if visited.include?(simplified)
    visited << simplified
    return distance if hash.all? { _2 == 3 }

    current_level = hash['E']
    on_current_level = hash.select { _2 == current_level }.keys
    on_current_level.delete('E')

    (on_current_level.combination(1) + on_current_level.combination(2)).each do |to_move|
      [-1, 1].each do |ld|
        new_level = current_level + ld
        next if new_level < 0 || new_level > 3

        to_queue = hash.dup
        to_queue['E'] = new_level
        to_move.each { to_queue[it] = new_level }

        next unless valid?(to_queue)

        queue << [to_queue, distance + 1, path + [to_queue]]
      end
    end
  end
end

def part2(input)
  input = input.dup
  input['EG'] = 0
  input['EC'] = 0
  input['DG'] = 0
  input['DC'] = 0
  part1(input)
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(11, part1(parse('sample')))
  end
end
