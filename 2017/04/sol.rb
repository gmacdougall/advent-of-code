#! /usr/bin/env ruby
# frozen_string_literal: true

def valid?(passphrase)
  passphrase.split(' ').tally.map(&:last).max == 1
end

def valid_anagram?(passphrase)
  passphrase.split(' ').map { it.chars.sort }.tally.map(&:last).max == 1
end

def part1(input)
  input.lines(chomp: true).count { valid? it }
end

def part2(input)
  input.lines(chomp: true).count { valid_anagram? it }
end

puts "Part 1: #{part1(File.read('input'))}"
puts "Part 2: #{part2(File.read('input'))}"

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_valid
    assert(valid?('aa bb cc dd ee'))
    assert(!valid?('aa bb cc dd aa'))
    assert(valid?('aa bb cc dd aaa'))
  end

  def test_valid2
    assert(valid_anagram?('abcde fghij'))
    assert(!valid_anagram?('abcde xyz ecdab'))
    assert(valid_anagram?('a ab abc abd abf abj'))
    assert(valid_anagram?('iiii oiii ooii oooi oooo'))
    assert(!valid_anagram?('oiii ioii iioi iiio'))
  end
end
