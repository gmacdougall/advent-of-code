#! /usr/bin/env ruby
# frozen_string_literal: true

HAND_VALUE = [
  HIGH_CARD = [1, 1, 1, 1, 1].freeze,
  ONE_PAIR = [1, 1, 1, 2].freeze,
  TWO_PAIR = [1, 2, 2].freeze,
  THREE_OF_A_KIND = [1, 1, 3].freeze,
  FULL_HOUSE = [2, 3].freeze,
  FOUR_OF_A_KIND = [1, 4].freeze,
  FIVE_OF_A_KIND = [5].freeze,
].freeze

CARD_VALUE = %w[J 2 3 4 5 6 7 8 9 T Q K A].freeze

class Hand
  include Comparable
  attr_reader :bid

  def initialize(cards, bid)
    @cards = cards
    @bid = bid
  end

  def <=>(other)
    rank <=> other.rank
  end

  def rank
    @rank ||= [
      HAND_VALUE.index(tally),
      *@cards.map { CARD_VALUE.index(_1) }
    ]
  end

  def tally
    @cards.tally.tap do |tally|
      if tally['J'] && tally['J'] < 5
        jokers = tally.delete('J')
        tally[tally.max_by { _2 }.first] += jokers
      end
    end.map(&:last).sort
  end
end

def parse(file)
  file.lines.map(&:split).map { Hand.new(_1.chars, _2.to_i) }
end

def part2(hands)
  hands.sort.each_with_index.sum { _1.bid * (_2 + 1) }
end


if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 2: #{part2(input)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    parse(File.read('sample'))
  end

  def test_part2
    assert_equal(5905, part2(sample))
  end
end
