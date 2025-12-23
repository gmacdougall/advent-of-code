#! /usr/bin/env ruby
# frozen_string_literal: true

def inverse(a, b) = aba?(a) && aba?(b) && a[0] == b[1] && a[1] == b[0]
def aba?(chars) = chars[0] == chars[2] && chars[0] != chars[1]

def abba?(chars)
  chars[0] == chars[3] && chars[1] == chars[2] && chars[0] != chars[1]
end

def supports_tls?(str)
  hypernet_seqs = str.scan(/\[\w+\]/)

  hypernet_seqs.each do |seq|
    return false if seq.chars.each_cons(4).any? { abba? it }
  end

  regular = str.split(/\[\w+\]/)
  regular.each do |seq|
    return true if seq.chars.each_cons(4).any? { abba? it }
  end

  false
end


def supports_ssl?(str)
  aba_char_seq = ->(seq) { seq.chars.each_cons(3).select { aba? it } }
  hypernet_seqs = str.scan(/\[\w+\]/)
  regular = str.split(/\[\w+\]/)

  h = hypernet_seqs.flat_map(&aba_char_seq)
  r = regular.flat_map(&aba_char_seq)

  h.product(r).any? { inverse(_1, _2) }
end

def part1(fname)
  File.read(fname).lines(chomp: true).count { supports_tls? it }
end

def part2(fname)
  File.read(fname).lines(chomp: true).count { supports_ssl? it }
end

if File.exist?('input')
  puts "Part 1: #{part1('input')}"
  puts "Part 2: #{part2('input')}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_supports_tls?
    assert(supports_tls?('abba[mnop]qrst'))
    assert(!supports_tls?('abcd[bddb]xyyx'))
    assert(!supports_tls?('aaaa[qwer]tyui'))
    assert(supports_tls?('ioxxoj[asdfgh]zxcvbn'))
  end

  def test_supports_ssl?
    assert(supports_ssl?('aba[bab]xyz'))
    assert(!supports_ssl?('xyx[xyx]xyx'))
    assert(supports_ssl?('aaa[kek]eke'))
    assert(supports_ssl?('zazbz[bzb]cdb'))
  end
end
