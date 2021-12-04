#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.each_line.map(&:strip).reject(&:empty?)
cards = input[1..].map { |a| a.split(/\s+/).map(&:to_i) }.each_slice(5).flat_map { |a| [a, a.transpose] }
numbers = input.first.split(',').map(&:to_i)

numbers.each_with_index do |n, idx|
  selected = numbers[0..idx]
  cards.each do |card|
    card.each do |row|
      next unless (row & selected).length == 5

      puts n * (card.flatten - selected).sum
      exit
    end
  end
end
