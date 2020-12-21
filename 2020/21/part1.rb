#! /usr/bin/env ruby
# frozen_string_literal: true

all_ingredients = []
possibilities = {}

ARGF.lines.map(&:strip).each do |line|
  ingredients, allergens = line.match(/(.*) \(contains (.*)\)/).captures
  ingredients = ingredients.split(' ')
  all_ingredients += ingredients
  allergens = allergens.split(', ')

  allergens.each do |a|
    if possibilities[a]
      possibilities[a] &= ingredients
    else
      possibilities[a] = ingredients
    end
  end
end

safe = all_ingredients.reject do |i|
  possibilities.values.flatten.include?(i)
end

p safe.count
