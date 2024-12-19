#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  available, options = File.read(fname).split("\n\n")
  [
    available.strip.split(', ').map(&:chars),
    options.lines.map { _1.strip.chars }
  ]
end

def possibilities(available, option)
  possibilities = Hash.new(0)
  possibilities[0] = 1
  (0...option.size).each do |opt_len|
    available.each do |to_try|
      match = to_try.each_with_index.all? { |chr, idx| option[opt_len + idx] == chr }
      possibilities[opt_len + to_try.size] += possibilities[opt_len] if match
    end
  end
  possibilities[option.size]
end

def part2(available, options)
  options.sum { |opt| possibilities(available, opt) }
end

puts "Part 2: #{part2(*parse('input'))}" if File.exist?('input')

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_possibilities
    available, _options = parse('sample')
    assert_equal(2, possibilities(available, 'brwrr'))
    assert_equal(1, possibilities(available, 'bggr'))
    assert_equal(4, possibilities(available, 'gbbr'))
    assert_equal(6, possibilities(available, 'rrbgbr'))
    assert_equal(1, possibilities(available, 'bwurrg'))
    assert_equal(2, possibilities(available, 'brgr'))
    assert_equal(0, possibilities(available, 'ubwu'))
    assert_equal(0, possibilities(available, 'bbrgwb'))
  end

  def test_part2
    assert_equal(16, part2(*parse('sample')))
  end
end
