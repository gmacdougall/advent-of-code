#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.chop.to_i(16).to_s(2).chars
input.unshift('0') while (input.length % 4) != 0

def parse_packet(input)
  input.shift(3)
  packet_type = input.shift(3).join.to_i(2)
  case packet_type
  when 4
    value = ''
    loop do
      more, *rest = input.shift(5)
      value += rest.join
      break if more == '0'
    end
    value.to_i(2)
  else
    subpackets = []
    length_type_id = input.shift(1).first.to_i
    if length_type_id.zero?
      length = input.shift(15).join.to_i(2)
      slice = input.shift(length)
      subpackets << parse_packet(slice) while slice.any?
    elsif length_type_id == 1
      number_of_subpackets = input.shift(11).join.to_i(2)
      subpackets = Array.new(number_of_subpackets) { parse_packet(input) }
    else
      raise
    end

    case packet_type
    when 0
      subpackets.sum
    when 1
      subpackets.inject(:*)
    when 2
      subpackets.min
    when 3
      subpackets.max
    when 5
      subpackets[0] > subpackets[1] ? 1 : 0
    when 6
      subpackets[0] < subpackets[1] ? 1 : 0
    when 7
      subpackets[0] == subpackets[1] ? 1 : 0
    end
  end
end

puts parse_packet(input)
