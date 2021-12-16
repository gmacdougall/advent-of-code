#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.chop.to_i(16).to_s(2).chars
input.unshift('0') while (input.length % 4) != 0
@version_numbers = 0

def parse_packet(input)
  packet_version = input.shift(3).join.to_i(2)
  @version_numbers += packet_version
  packet_type = input.shift(3).join.to_i(2)
  case packet_type
  when 4
    value = ''
    loop do
      more, *rest = input.shift(5)
      value += rest.join
      break if more == '0'
    end
    value = value.to_i(2)
  else
    length_type_id = input.shift(1).first.to_i
    if length_type_id.zero?
      length = input.shift(15).join.to_i(2)
      slice = input.shift(length)
      parse_packet(slice) while slice.any?
    elsif length_type_id == 1
      number_of_subpackets = input.shift(11).join.to_i(2)
      number_of_subpackets.times.map do
        parse_packet(input)
      end
    else
      raise
    end
  end
end

parse_packet(input)
puts @version_numbers
