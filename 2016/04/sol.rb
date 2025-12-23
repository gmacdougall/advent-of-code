#! /usr/bin/env ruby
# frozen_string_literal: true

def sector(str)
  *parts, last = str.split('-')
  id, checksum = last.match(/(\d+)\[(\w+)\]/).captures

  checksum = checksum.chars.sort
  chars = parts.join.chars.tally.map { [-_2, _1] }.sort
  common = chars.first(5).map(&:last).sort

  id.to_i if checksum == common
end

START = 'a'.ord

def decrypt(str)
  *parts, last = str.split('-')
  id = last.match(/(\d+)/).captures.first.to_i

  parts.map do |part|
    part.chars.map { ((it.ord - START + id) % 26 + START).chr }.join
  end.join(' ')
end

def part1(fname)
  File.read(fname).lines(chomp: true).filter_map do |str|
    sector(str)
  end.sum
end

def part2(fname)
  File.read(fname).lines(chomp: true).filter_map do |str|
    decrypted = decrypt(str)
    "#{str} => #{decrypted}" if decrypted.include?('pole')
  end.first
end

if File.exist?('input')
  puts "Part 1: #{part1('input')}"
  puts "Part 2: #{part2('input')}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_sector
    assert_equal(123, sector('aaaaa-bbb-z-y-x-123[abxyz]'))
    assert_equal(987, sector('a-b-c-d-e-f-g-h-987[abcde]'))
    assert_equal(404, sector('not-a-real-room-404[oarel]'))
    assert_nil(sector('totally-real-room-200[decoy]'))
  end

  def test_decrypt
    assert_equal('very encrypted name', decrypt('qzmt-zixmtkozy-ivhz-343'))
  end
end
