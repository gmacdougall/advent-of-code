#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true)
end

def part1(instructions, str)
  str = str.dup
  instructions.each do |line|
    words = line.split
    if words[0] == 'swap' && words[1] == 'position'
      x, y = words[2].to_i, words[5].to_i
      str[x], str[y] = str[y], str[x]
    elsif words[0] == 'swap' && words[1] == 'letter'
      x, y = str.index(words[2]), str.index(words[5])
      str[x], str[y] = str[y], str[x]
    elsif words[0] == 'reverse'
      x, y = [words[2].to_i, words[4].to_i].sort
      new_str = ''
      new_str += str[..(x-1)] if x > 0
      new_str += str[x..y].reverse
      new_str += str[(y+1)..] if y < str.length - 1
      str = new_str
    elsif words[0] == 'rotate' && words[1] != 'based'
      amt = words[2].to_i
      dir = words[1] == 'left' ? amt : -amt
      str = str.chars.rotate(dir).join
    elsif words[0] == 'rotate' && words[1] == 'based'
      amt = str.index(words[6])
      amt += 1 if amt >= 4
      amt += 1
      str = str.chars.rotate(-amt).join
    elsif words[0] == 'move'
      from, to = words[2].to_i, words[5].to_i
      chars = str.chars
      char = chars.delete_at(from)
      chars.insert(to, char)
      str = chars.join
    else
      fail
    end
  end
  str
end

def part2(instructions, target)
  'abcdefgh'.chars.permutation(8).map(&:join).find do |str|
    target == part1(instructions, str)
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'), 'abcdefgh')}"
  puts "Part 2: #{part2(parse('input'), 'fbgdceah')}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal('decab', part1(parse('sample'), 'abcde'))
  end
end
