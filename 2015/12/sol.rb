#! /usr/bin/env ruby
# frozen_string_literal: true

require 'json'

def part1(fname)
  File.read(fname).scan(/-?\d+/).map(&:to_i).sum
end

def part2(fname)
  queue = [JSON.parse(File.read(fname))]
  sum = 0
  while queue.any?
    node = queue.pop
    case node
    when Array
      queue += node.flatten
    when Hash
      queue += node.values unless node.values.include?('red')
    when String
      # no-op
    when Integer
      sum += node
    else
      binding.irb
      fail
    end
  end
  sum
end

if File.exist?('input')
  puts "Part 1: #{part1('input')}"
  puts "Part 2: #{part2('input')}"
end
