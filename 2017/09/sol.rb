#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  Stream.new.add(File.read(fname).strip)
end

class Stream
  def initialize
    @state = :normal
    @group = 0
    @score = 0
    @garbage_characters = 0
  end

  attr_reader :garbage_characters, :state

  def add(str)
    @chars = str.chars
    self
  end

  def step
    char = @chars.shift

    if state == :escape_garbage
      @state = :garbage
    elsif state == :escape_normal
      @state = :normal
    elsif state == :normal
      case char
      when '<'
        @state = :garbage
      when '!'
        @state = :escape_normal
      when '{'
        @group += 1
        @score += @group
      when '}'
        @group -= 1
      end
    elsif state == :garbage
      case char
      when '!'
        @state = :escape_garbage
      when '>'
        @state = :normal
      else
        @garbage_characters += 1
      end
    else
      raise
    end
    @state
  end

  def run
    step while @chars.any?
    @score
  end
end

if File.exist?('input')
  s = parse('input')
  puts "Part 1: #{s.run}"
  puts "Part 2: #{s.garbage_characters}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_garbage
    s = Stream.new
    s.add '<>'
    assert_equal(s.state, :normal)
    assert_equal(s.step, :garbage)
    assert_equal(s.step, :normal)

    s.add '<<<<>'
    4.times { assert_equal(s.step, :garbage) }
    assert_equal(s.step, :normal)

    s.add '<{!>}>'
    2.times { assert_equal(s.step, :garbage) }
    assert_equal(s.step, :escape_garbage)
    2.times { assert_equal(s.step, :garbage) }
    assert_equal(s.step, :normal)

    s.add '<!!!>>'
    assert_equal(s.step, :garbage)
    assert_equal(s.step, :escape_garbage)
    assert_equal(s.step, :garbage)
    assert_equal(s.step, :escape_garbage)
    assert_equal(s.step, :garbage)
    assert_equal(s.step, :normal)
  end

  def test_foo
    s = Stream.new
    s.add '{{{},{},{{}}}}'
    assert_equal(16, s.run)

    s = Stream.new
    s.add '{{<!!>},{<!!>},{<!!>},{<!!>}}'
    assert_equal(9, s.run)
  end
end
