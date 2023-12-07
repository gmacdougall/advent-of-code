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

CARD_VALUE = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze

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
      HAND_VALUE.index(@cards.tally.map(&:last).sort),
      *@cards.map { CARD_VALUE.index(_1) }
    ]
  end
end

def parse(file)
  file.lines.map(&:split).map { Hand.new(_1.chars, _2.to_i) }
end

def part1(hands)
  hands.sort.each_with_index.sum { _1.bid * (_2 + 1) }
end


if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{part1(input)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    parse(File.read('sample'))
  end

  def test_part1
    assert_equal(6440, part1(sample))
  end
end
