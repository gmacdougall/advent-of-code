#!/usr/bin/env ruby

pots = '.' * 20
pots += ARGF.read.chomp
pots += '.' * 20

lookup = Hash.new('.')
lookup['.#.##'] = '#'
lookup['.#.#.'] = '#'
lookup['#.#.#'] = '.'
lookup['.####'] = '.'
lookup['.#...'] = '.'
lookup['#..##'] = '.'
lookup['..#.#'] = '#'
lookup['#.#..'] = '.'
lookup['#####'] = '.'
lookup['....#'] = '.'
lookup['...##'] = '.'
lookup['..##.'] = '.'
lookup['##.#.'] = '#'
lookup['##..#'] = '.'
lookup['##...'] = '#'
lookup['..###'] = '#'
lookup['.##..'] = '#'
lookup['###..'] = '.'
lookup['#..#.'] = '.'
lookup['##.##'] = '.'
lookup['..#..'] = '#'
lookup['.##.#'] = '#'
lookup['####.'] = '#'
lookup['#.###'] = '.'
lookup['#...#'] = '#'
lookup['###.#'] = '#'
lookup['...#.'] = '#'
lookup['.###.'] = '.'
lookup['.#..#'] = '#'
lookup['.....'] = '.'
lookup['#....'] = '.'
lookup['#.##.'] = '#'

20.times do
  next_generation = '..'
  (0..(pots.length - 5)).each do |idx|
    next_generation += lookup[pots[idx, 5]]
  end
  next_generation += '..'
  pots = next_generation
  puts pots
end

result = 0
pots.split('').each_with_index do |val, idx|
  result += idx - 20 if val == '#'
end

puts result
