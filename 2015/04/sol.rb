#! /usr/bin/env ruby
# frozen_string_literal: true

require 'digest/md5'

def sol(key, n)
  start_with = '0' * n
  (1..).find do |n|
    Digest::MD5.hexdigest("#{key}#{n}").start_with?(start_with)
  end
end

def part1(key) = sol(key, 5)
def part2(key) = sol(key, 6)

if File.exist?('input')
  puts "Part 1: #{part1(File.read('input').strip)}"
  puts "Part 2: #{part2(File.read('input').strip)}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(609043, part1('abcdef'))
    assert_equal(1048970, part1('pqrstuv'))
  end
end
