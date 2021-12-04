#! /usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.split("\n").map(&:strip).reject(&:empty?)
cards = input[1..].map { |a| a.split(/\s+/).map(&:to_i) }.each_slice(5).to_a
numbers = input.first.split(',').map(&:to_i)
loser = nil

numbers.each_with_index do |n, idx|
  selected = numbers[0..idx]
  cards.reject! do |card|
    [card, card.transpose].any? do |c|
      c.any? { |row| (row & selected).length == 5 }
    end
  end

  loser = cards.first if !loser && cards.length == 1
  next if cards.any?

  puts n * (loser.flatten - selected).sum
  exit
end
