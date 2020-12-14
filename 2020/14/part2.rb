#! /usr/bin/env ruby
# frozen_string_literal: true

def r(arr, chars)
  return arr.map { |a| a.to_i(2) } if chars.empty?

  chr = chars.shift
  new_arr = if chr == 'X'
              %w[0 1].flat_map { |c| arr.map { |val| val + c } }
            else
              arr.map { |val| val + chr }
            end
  r(new_arr, chars)
end

input = ARGF.lines.map(&:strip)

memory = {}
current_mask = nil

input.each do |line|
  if line.start_with?('mask = ')
    current_mask = line.gsub('mask = ', '')
  else
    addr, val = line.match(/mem\[(\d+)\] = (\d+)/).captures.map(&:to_i)
    bin = addr.to_s(2).rjust(current_mask.length, '0')

    masked = bin.chars.each_with_index.map do |chr, idx|
      if %w[1 X].include?(current_mask[idx])
        current_mask[idx]
      else
        chr
      end
    end
    r([''], masked).each { |masked_addr| memory[masked_addr] = val }
  end
end

p memory.values.compact.sum
