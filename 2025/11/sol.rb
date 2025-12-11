#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  File.read(fname).lines(chomp: true).map do
    from, to = it.split(': ')
    to = to.split ' '
    [from, to]
  end.to_h.merge('out' => [])
end

def tsort(input)
  indegree = (input.values.flatten + input.keys).tally.transform_values { it - 1 }

  queue = indegree.select { _2.zero? }.keys
  order = []

  while node = queue.pop
    order << node
    indegree.delete(node)

    input[node].each { indegree[_1] -= 1 }

    indegree.select { _2.zero? }.keys.each { queue << _1 unless queue.include?(_1) }
  end
  order
end

def count_ways(input, order, source, dest)
  ways = Hash.new(0)
  ways[source] = 1

  order.each do |node|
    input[node].each do |adj|
      ways[adj] += ways[node]
    end
  end
  ways[dest]
end

def part1(input)
  count_ways(input, tsort(input), 'you', 'out')
end

def part2(input)
  order = tsort(input)

  svr_to_dac = count_ways(input, order, 'svr', 'dac')
  svr_to_fft = count_ways(input, order, 'svr', 'fft')

  dac_to_fft = count_ways(input, order, 'dac', 'fft')
  fft_to_dac = count_ways(input, order, 'fft', 'dac')

  dac_to_out = count_ways(input, order, 'dac', 'out')
  fft_to_out = count_ways(input, order, 'fft', 'out')

  svr_to_dac * dac_to_fft * fft_to_out + svr_to_fft * fft_to_dac * dac_to_out
end

if File.exist?('input')
  puts "Part 1: #{part1(parse('input'))}"
  puts "Part 2: #{part2(parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(5, part1(parse('sample')))
  end

  def test_part2
    assert_equal(2, part2(parse('sample2')))
  end
end
