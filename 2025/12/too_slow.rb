#! /usr/bin/env ruby
# frozen_string_literal: true

def parse(fname)
  input = File.read(fname).split("\n\n")
  presents = input.shift(6).map { it.lines.last(3).map { |l| l.strip.gsub('#', '1').gsub('.', '0').chars.map(&:to_i) }}
  areas = input.first.lines(chomp: true).map do |line|
    area, foo = line.split(': ')
    [area.split('x').map(&:to_i), foo.split(' ').map(&:to_i)]
  end
  [presents, areas]
end

def to_bin(present, x, y, xo, yo)
  to_bin_str(present, x, y, xo, yo).to_i(2)
end

def to_bin_str(present, x, y, xo, yo)
  dump(present, x, y, xo, yo).gsub("\n", '').gsub('#', '1').gsub('.', '0')
end

def dump(present, x, y, xo, yo)
  str = "\n"
  y.times do |cy|
    x.times do |cx|
      str += !(cy-yo).negative? && !(cx-xo).negative? && present.dig(cy - yo, cx - xo) == 1 ? '#' : '.'
    end
    str += "\n"
  end
  str
end

def valid?(presents, x, y, requirements)
  bin_presents = presents.map do |present|
    4.times.flat_map do |rotation|
      present = present.transpose.map(&:reverse)
      (0..(y-3)).flat_map do |yo|
        (0..(x-3)).flat_map do |xo|
          to_bin(present, x, y, xo, yo)
        end
      end
    end
  end

  combos = bin_presents.each_with_index.map do |bp, idx|
    bp.combination(requirements[idx]).filter_map do |com|
      if com.empty?
        0
      elsif com.length == 1
        com.first
      else
        com.inject(:|) if com.inject(:&).zero?
      end
    end
  end

  a, b, c, d, e, f = combos

  puts "Expecting #{a.size * b.size * c.size * d.size * e.size * f.size} iterations"
  a.each do |aa|
    b.each do |bb|
      c.each do |cc|
        d.each do |dd|
          e.each do |ee|
            f.each do |ff|
              return true if aa & bb && cc && dd && ee && ff == 0
            end
          end
        end
      end
    end
  end
  false
end


def part1(presents, areas)
  areas.count do |(x, y), requirements|
    valid?(presents, x, y, requirements)
  end
end

if File.exist?('input')
  puts "Part 1: #{part1(*parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(2, part1(*parse('sample')))
  end
end
