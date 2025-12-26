#! /usr/bin/env ruby
# frozen_string_literal: true

def valid_str?(pass)
  valid_chars?(pass.chars)
end

def valid_chars?(chars)
  !chars.include?('i') &&
    !chars.include?('o') &&
    !chars.include?('l') &&
    chars.each_cons(3).any? { _1.ord + 1 == _2.ord && _2.ord + 1 == _3.ord } &&
    chars.each_cons(2).select { _1 == _2 }.flatten.uniq.count >= 2
end

def sol(after)
  chars = after.chars
  loop do
    idx = -1
    loop do
      chars[idx] = chars[idx].succ
      break unless chars[idx] == 'aa'
      chars[idx] = 'a'
      idx -= 1
    end
    return chars.join if valid_chars?(chars)
  end
end


if File.exist?('input')
  part1 = sol(File.read('input').strip)
  puts "Part 1: #{part1}"
  puts "Part 2: #{sol(part1)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_valid
    assert(!valid_str?('hijklmmn'))
    assert(!valid_str?('abbceffg'))
    assert(!valid_str?('abbcegjk'))
    assert(valid_str?('abcdffaa'))
    assert(valid_str?('ghjaabcc'))
  end

  def test_sol
    assert_equal('abcdffaa', sol('abcdefgh'))
  end
end
