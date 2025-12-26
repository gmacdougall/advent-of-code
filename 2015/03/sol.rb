#! /usr/bin/env ruby
# frozen_string_literal: true

def part1(str)
  visits = Hash.new(0)
  x = y = 0
  visits[[x, y]] += 1
  str.chars.each do |chr|
    case chr
    when '<'
      x -= 1
    when '>'
      x += 1
    when '^'
      y -= 1
    when 'v'
      y += 1
    else
      fail
    end
    visits[[x, y]] += 1
  end
  visits.count
end

def part2(str)
  visits = Hash.new(0)
  santas = [
    [0, 0],
    [0, 0],
  ]
  visits[[0, 0]] += 2
  str.chars.each do |chr|
    case chr
    when '<'
      santas[0][0] -= 1
    when '>'
      santas[0][0] += 1
    when '^'
      santas[0][1] -= 1
    when 'v'
      santas[0][1] += 1
    else
      fail
    end
    visits[santas[0].dup] += 1
    santas.rotate!
  end
  visits.count
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip)}"
  puts "Part 2: #{part2(File.read('input').strip)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(2, part1('>'))
    assert_equal(4, part1('^>v<'))
    assert_equal(2, part1('^v^v^v^v^v'))
  end

  def test_part2
    assert_equal(3, part2('^v'))
    assert_equal(3, part2('^>v<'))
    assert_equal(11, part2('^v^v^v^v^v'))
  end
end
