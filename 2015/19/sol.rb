#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).each_with_object({}) do |line, hash|
    next unless line.include?('=>')

    from, to = line.split(' => ')

    hash[from] ||= []
    hash[from] << to
  end
end

def to_arr(str) = str.scan(/[A-Z][a-z]?/)

def part1(input, str)
  elements = to_arr(str)

  found = Set.new
  elements.each_with_index do |curr, idx|
    next unless input[curr]

    input[curr].each do |rep|
      gen = elements.dup
      gen[idx] = rep
      found << gen.join
    end
  end

  found.size
end

# This isn't a general case, but it does get the right answer going big to small
def part2(input, str)
  reverse = input.flat_map { |a, b| b.map { [to_arr(_1), a] } }.to_h
  combo_sizes = reverse.keys.map(&:length).uniq.sort.reverse

  elements = to_arr(str)

  count = 0
  loop do
    break if elements.empty?

    combo_sizes.flat_map do |size|
      result = elements.each_cons(size).select { reverse.key? _1 }
      next if result.empty?

      count += 1
      to_replace = result.last
      elements = to_arr(elements.join.sub(to_replace.join, reverse[to_replace]))
      break
    end
  end
  count
end

if File.exist?('input')
  molecule = File.read('input').lines.last.strip
  puts "Part 1: #{part1(parse('input'), molecule)}"
  puts "Part 2: #{part2(parse('input'), molecule)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(4, part1(parse('sample'), 'HOH'))
    assert_equal(7, part1(parse('sample'), 'HOHOHO'))
  end
end
