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

while possibilities.values.any? { |v| v.count > 1 }
  known = possibilities.values.select { |v| v.count == 1 }.flatten
  possibilities.transform_values! do |v|
    if v.count > 1
      v - known
    else
      v
    end
  end
end

p possibilities.sort.map(&:last).flatten.join(',')
