#! /usr/bin/env ruby
# frozen_string_literal: true

require 'digest/md5'

def enum(str)
  Enumerator.new do |e|
    (0..).each do |n|
      digest = Digest::MD5.hexdigest("#{str}#{n.to_s}")
      e.yield digest[5..6] if digest.start_with?('00000')
    end
  end
end

def part1(str)
  gen = enum(str)
  gen.first(8).map { it[0] }.join
end

def part2(str)
  gen = enum(str)
  pass = Array.new(8)

  while !pass.all?
    idx, chr = gen.next.chars
    pass[idx.to_i] ||= chr if ('0'..'7').cover?(idx)
  end
  pass.join
end

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip)}"
  puts "Part 2: #{part2(File.read('input').strip)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal('18f47a30', part1('abc'))
  end

  def test_part2
    assert_equal('05ace8e3', part2('abc'))
  end
end
