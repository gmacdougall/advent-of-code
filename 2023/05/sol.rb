#! /usr/bin/env ruby
# frozen_string_literal: true

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end


class SeedMap
  def initialize(string)
    seeds, _, *rest = string.lines.map(&:strip)
    @seeds = seeds.split[1..].map(&:to_i)
    @maps = {}
    curr = nil
    rest.each do |line|
      if line.include?('map')
        from, _, to = line.scan(/\w+/)
        curr = { from:, to: }
        @maps[curr] = []
      elsif line.length > 0
        dest, source, range_length = line.split.map(&:to_i)
        @maps[curr] << { dest: dest, source: source..(source + range_length), diff: dest - source }
      end
    end
  end

  def part1
    seeds = @seeds.dup
    @maps.each do |_, values|
      seeds = seeds.map do |n|
        map = values.find { _1[:source].cover?(n) }
        map ? n - map[:source].min + map[:dest] : n
      end
    end
    seeds.min
  end

  def part2
    seeds = @seeds.each_slice(2).flat_map { (_1..(_1 + _2)) }
    @maps.each do |_, values|
      new_seeds = []
      values.each do |v|
        seeds = seeds.flat_map do |s|
          if s.overlaps?(v[:source])
            new_seeds << (([s.min, v[:source].min].max + v[:diff])..([s.max, v[:source].max].min + v[:diff]))

            [
              (s.min < v[:source].min) && (s.min..(v[:source].min - 1)),
              (s.max > v[:source].max) && ((v[:source].max + 1)..s.max),
            ].select { _1 }
          else
            s
          end
        end.compact
      end
      seeds += new_seeds
    end
    seeds.map(&:min).min
  end
end

if File.exist?('input')
  input = SeedMap.new(File.read('input'))
  puts "Part 1: #{input.part1}"
  puts "Part 2: #{input.part2}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    SeedMap.new(File.read('sample'))
  end

  def test_part1
    assert_equal(35, sample.part1)
  end

  def test_part2
    assert_equal(46, sample.part2)
  end
end
