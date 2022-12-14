#! /usr/bin/env ruby

input = ARGF.map(&:strip).map { |s| s.split(' -> ').map { _1.split(',').map(&:to_i) } }

wall = [] 
input.each do |set|
  set.each_cons(2).each do |(x1, y1), (x2, y2)|
    Range.new(*[x1, x2].sort).each do |x|
      Range.new(*[y1, y2].sort).each do |y|
        wall << [x, y]
      end
    end
  end
end

y_max = wall.map(&:last).max

points = {}
wall.each { points[_1] = '#' }
count = 0

sand_source = [500, 0]

loop do
  x, y = sand_source.dup

  loop do
    if points[[x, y+1]].nil?
      y += 1
      if y > y_max
        puts count
        exit
      end
    elsif points[[x-1, y+1]].nil?
      x -= 1
      y += 1
    elsif points[[x+1, y+1]].nil?
      x += 1
      y += 1
    else
      count += 1
      p [x, y]
      points[[x, y]] = 'S'
      break
    end
  end
end
