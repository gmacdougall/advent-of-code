#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).map(&:chars)
end

DIR = {
  up: [0, -1],
  down: [0, 1],
  left: [-1, 0],
  right: [1, 0],
}.freeze

DIR_SEARCH = {
  up: %i[left right],
  down: %i[left right],
  left: %i[up down],
  right: %i[up down],
}

VALID_DIR = {
  up: '|',
  down: '|',
  left: '-',
  right: '-',
}.freeze

LETTERS = 'A'..'Z'.freeze

def solve(input)
  path = []
  steps = 0
  dir = :down

  x = input[0].index('|')
  y = 0

  loop do
    dx, dy = DIR[dir]

    case here = input[y][x]
    when '+'
      dir = DIR_SEARCH[dir].find do |new_dir|
        cx, cy = DIR[new_dir]
        potential = input[y + cy][x + cx]
        LETTERS.cover?(potential) || potential == VALID_DIR[new_dir]
      end
      dx, dy = DIR[dir]
      x += dx
      y += dy
      steps += 1
    when ' ', nil
      return [path.join, steps]
    else
      path << here if LETTERS.cover?(here)
      x += dx
      y += dy
      steps += 1
    end
  end
end

if File.exist?('input')
  part1, part2, = solve(parse('input'))
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_solve
    assert_equal('ABCDEF', solve(parse('sample')).first)
    assert_equal(38, solve(parse('sample')).last)
  end
end
