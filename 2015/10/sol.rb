#! /usr/bin/env ruby
# frozen_string_literal: true

def look_and_say(str)
  str.chars.chunk_while { _1 == _2 }.map { "#{_1.count}#{_1.first}" }.join
end

if File.exist?('input')
  val = File.read('input').strip
  40.times do |n|
    val = look_and_say(val)
  end
  puts "Part 1: #{val.length}"
  (40...50).each do |n|
    val = look_and_say(val)
  end
  puts "Part 2: #{val.length}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_look_and_say
    assert_equal('11', look_and_say('1'))
    assert_equal('21', look_and_say('11'))
    assert_equal('1211', look_and_say('21'))
    assert_equal('111221', look_and_say('1211'))
    assert_equal('312211', look_and_say('111221'))
  end
end
