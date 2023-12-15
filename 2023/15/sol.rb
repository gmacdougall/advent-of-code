#! /usr/bin/env ruby
# frozen_string_literal: true

class String
  def hash
    self.chars.inject(0) { |val, chr| ((val + chr.ord) * 17) % 256 }
  end
end

def part1(instructions)
  instructions.sum(&:hash)
end

def part2(instructions)
  instructions.each_with_object(Array.new(256) { Hash.new }) do |inst, boxes|
    label, op, focal_length = inst.match(/(\w+)(\-|=)(.*)/).captures

    if op == '='
      boxes[label.hash][label] = focal_length.to_i
    else
      boxes.each { _1.delete(label) }
    end
  end.each_with_index.sum do |contents, box_num|
    (box_num + 1) * contents.values.each_with_index.sum { _1 * (_2 + 1) }
  end
end

if File.exist?('input')
  input = File.read('input').strip.split(',')
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2(input)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def sample
    'rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7'.split(',')
  end

  def test_hash
    assert_equal(52, 'HASH'.hash)
  end

  def test_part1
    assert_equal(1320, part1(sample))
  end

  def test_part1
    assert_equal(145, part2(sample))
  end
end
