#! /usr/bin/env ruby
# frozen_string_literal: true

require 'digest/md5'

REGEX = (('0'..'9').to_a + ('a'..'f').to_a).map do |chr|
  [chr, /#{chr}{5}/]
end.to_h

HASH_CACHE = {}

def digest(str, loops)
  HASH_CACHE[loops] ||= {}
  return HASH_CACHE[loops][str] if HASH_CACHE[loops].key?(str)

  to_hash = str
  loops.times do
    result = Digest::MD5.hexdigest(to_hash)
    HASH_CACHE[loops][str] = result
    to_hash = result
  end
  to_hash
end

def enum(str, loops = 1)
  Enumerator.new do |e|
    (0..).each do |n|
      digest = digest("#{str}#{n.to_s}", loops)
      repeated_char = digest.chars.each_cons(3).find { _1 == _2 && _2 == _3 }
      next unless repeated_char
      repeated_char = repeated_char.first
      ((n+1)..(n+1_000)).each do |m|
        digest = digest("#{str}#{m.to_s}", loops)
        if digest.match?(REGEX[repeated_char])
          e.yield n
          break
        end
      end
    end
  end
end

def part1(salt)
  enum = enum(salt)
  enum.first(64).last
end

def part2(salt)
  enum = enum(salt, 2017)
  enum.first(64).last
end

puts "Part 1: #{part1('zpqevtbw')}"
puts "Part 2: #{part2('zpqevtbw')}"

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(22_728, part1('abc'))
  end

  def test_digest
    assert_equal('577571be4de9dcce85a041ba0410f29f', digest('abc0', 1))
    assert_equal('eec80a0c92dc8a0777c619d9bb51e910', digest('abc0', 2))
    assert_equal('16062ce768787384c81fe17a7a60c7e3', digest('abc0', 3))
    assert_equal('a107ff634856bb300138cac6568c0f24', digest('abc0', 2017))
  end

  def test_part2
    assert_equal(22_551, part2('abc'))
  end
end
