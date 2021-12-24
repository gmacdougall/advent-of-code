#! /usr/bin/env ruby
# frozen_string_literal: true

require 'set'

COST = {
  a: 1,
  b: 10,
  c: 100,
  d: 1000,
}.freeze

ROOM_RANGE = (11..18)
ROOMS = {
  a: 3,
  b: 0,
  c: 1,
  d: 2,
}.transform_values { |n| ROOM_RANGE.select { _1 % 4 == n } }.freeze

ADJACENT = [
  [1].freeze,
  [0, 2].freeze,
  [1, 3, 11].freeze,
  [2, 4].freeze,
  [3, 5, 12].freeze,
  [4, 6].freeze,
  [5, 7, 13].freeze,
  [6, 8].freeze,
  [7, 9, 14].freeze,
  [8, 10].freeze,
  [9].freeze,
  [2, 15].freeze,
  [4, 16].freeze,
  [6, 17].freeze,
  [8, 18].freeze,
  [11].freeze,
  [12].freeze,
  [13].freeze,
  [14].freeze
].freeze

FINISHED = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, :a, :b, :c, :d, :a, :b, :c, :d].freeze

ALL = Set.new(%i[a b c d]).freeze
NONE = [].freeze
VALID = [
  ALL,
  ALL,
  NONE,
  ALL,
  NONE,
  ALL,
  NONE,
  ALL,
  NONE,
  ALL,
  ALL,
  Set.new([:a]).freeze,
  Set.new([:b]).freeze,
  Set.new([:c]).freeze,
  Set.new([:d]).freeze,
  Set.new([:a]).freeze,
  Set.new([:b]).freeze,
  Set.new([:c]).freeze,
  Set.new([:d]).freeze
].freeze

def output(map)
  map = map.map { _1 ? _1.upcase : ' ' }
  puts '#############'
  puts "##{map.first(11).join}#"
  puts "####{map[11..14].join('#')}###"
  puts "  ##{map.last(4).join('#')}#  "
  puts '  #########  '
end

INPUT = ARGF.read.gsub(/\s/, '').gsub('#', '').downcase.chars.map { _1 == '.' ? nil : _1.to_sym }.freeze

states = { INPUT => 0 }
to_test = states.dup

def valid_move?(state, letter, idx)
  result = true
  # Don't move unless that is a valid location for that move
  result = false unless VALID[idx].include?(letter)
  # Don't move home unless the home is empty or only contains its friends
  result = false if ROOMS.include?(idx) && !ROOMS[letter].all? { state[_1].nil? || state[_1] == letter }
  # Don't move home unless it is going as far into the home as possible
  result = false if ROOMS.include?(idx) && ROOMS[letter].select { state[_1].nil }.max == idx
  result
end

def possible_spots(letter, to_check, state, result, distance = 0)
  distance += 1
  to_check.each do |idx|
    next if result.key?(idx)

    if state[idx]
      result[idx] = nil
    else
      result[idx] = valid_move?(state, letter, idx) ? distance : nil
      possible_spots(letter, ADJACENT[idx], state, result, distance)
    end
  end
  result
end

def make_all_possible_moves(state)
  new_states = {}
  state.each_with_index do |c, pos|
    # Don't move empty stuff
    next unless c
    # Don't move if home, and home doesn't have invaders
    next if ROOMS[c].include?(pos) && ROOMS[c].all? { state[_1].nil? || state[_1] == c }

    possible_spots(c, ADJACENT[pos], state, { pos => nil }).each do |new_pos, distance_travelled|
      # Restriction on moving around in top row
      next if pos < 11 && new_pos < 11
      next unless distance_travelled

      new_state = state.dup
      new_state[pos] = nil
      new_state[new_pos] = c
      new_states[new_state] = distance_travelled * COST.fetch(c)
    end
  end
  new_states
end

output states.first.first

while to_test.any?
  map, score = to_test.min_by(&:last)
  states[map] = score
  make_all_possible_moves(map).each do |new_state, score_to_add|
    if !states.key?(new_state) || states[new_state] > score + score_to_add
      states[new_state] = score + score_to_add
      to_test[new_state] = score + score_to_add
    end
  end
  print to_test.length, ', '
  puts score
  to_test.delete(map)
  break if states.key?(FINISHED)
end

puts states[FINISHED]
