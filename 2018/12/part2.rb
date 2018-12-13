#!/usr/bin/env ruby

pots = '.' * 20
pots += ARGF.read.chomp
pots += '.' * 200

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

200.times do |n|
  next_generation = '..'
  (0..(pots.length - 5)).each do |idx|
    next_generation += lookup[pots[idx, 5]]
  end
  next_generation += '..'
  pots = next_generation
  result = 0
  pots.split('').each_with_index do |val, idx|
    result += idx - 20 if val == '#'
  end
  puts "#{n} = #{result}"
end

puts 15 * (50_000_000_000 - 200) + 3697
