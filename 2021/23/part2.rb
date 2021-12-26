#! /usr/bin/env ruby
# frozen_string_literal: true

COST = {
  a: 1,
  b: 10,
  c: 100,
  d: 1000,
}.freeze
ROOM_SIZE = 4

EXIT = {
  a: 2,
  b: 4,
  c: 6,
  d: 8,
}.freeze

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

# TODO
class State
  attr_accessor :hall, :origin, :score, :home

  def initialize(hall, origin, home = 0)
    @hall = hall
    @origin = origin
    @home = home
    @score = 0
  end

  def self.from_str(s)
    new(s.first(11), COST.keys.zip(s[11..].each_slice(4).to_a.transpose).to_h)
  end

  def finished?
    home == ROOM_SIZE * 4
  end

  def eql?(other)
    [hall, origin, home] == [other.hall, other.origin, other.home]
  end

  def eligible_homes
    origin.select { |c, set| set.empty? && hall.include?(c) }.keys
  end

  def possible_moves
    result = []

    eligible_homes.each do |home|
      hall.each_index.select { |idx| hall[idx] == home }.each do |idx|
        range = Range.new(*[idx, EXIT[home]].sort)
        next unless hall[range].compact.length == 1

        new_state = dup
        new_state.score += (range.size - 1) * COST[home]
        new_state.hall[idx] = nil
        new_state.home += 1

        return [new_state]
      end
    end

    # Move into the hall
    origin.each do |key, o|
      next if o.empty?

      left = dup
      left.origin = origin.dup.transform_values(&:dup)
      left.hall = hall.dup
      moving_char = left.origin[key].shift
      left.hall[EXIT[key]] = moving_char
      right = left.dup
      right.hall = left.hall.dup

      # move left
      (EXIT[key] - 1).downto(0).each do |n|
        break if left.hall[n]

        left.hall[n] = left.hall[n + 1]
        left.hall[n + 1] = nil
        next if EXIT.values.include?(n)

        result << left.dup.tap do |copy|
          copy.hall = left.hall.dup
          copy.score += (EXIT[key] - n) * COST[moving_char]
        end
      end

      # move right
      (EXIT[key] + 1).upto(10).each do |n|
        break if right.hall[n]

        right.hall[n] = right.hall[n - 1]
        right.hall[n - 1] = nil
        next if EXIT.values.include?(n)

        result << right.dup.tap do |copy|
          copy.hall = right.hall.dup
          copy.score += (n - EXIT[key]) * COST[moving_char]
        end
      end
    end
    result
  end

  def to_s
    result = []
    result << "############# #{score}"
    result << "##{hall.map { _1.nil? ? ' ' : _1 }.join}#"
    result << "####{rooms.first.join('#')}###"
    rooms[1..].each do |set|
      result << "  ##{set.join('#')}#  "
    end
    result << '  #########  '
    result.join("\n").upcase
  end

  def set_minimum_score
    @score = 2 * rooms.each_with_index.sum do |room_set, idx|
      room_set.sum { |c| COST[c] * (idx + 1) }
    end
  end

  private

  def rooms
    Array.new(ROOM_SIZE) do |n|
      COST.keys.map { |k| @origin.dig(k, n) || ' ' }
    end
  end
end

INPUT = ARGF.read.gsub(/\s/, '').gsub('#', '').downcase.chars.map { _1 == '.' ? nil : _1.to_sym }.freeze
state = State.from_str(INPUT)
state.set_minimum_score

to_test = [state]
best_score = 1_000_000

while (state = to_test.pop)
  best_score = state.score if state.finished? && state.score < best_score

  state.possible_moves.each do |ns|
    to_test << ns
  end
end

puts best_score
