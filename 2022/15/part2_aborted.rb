#! /usr/bin/env ruby

input = ARGF.each_line.map(&:strip).map { _1.scan(/\-?\d+/).map(&:to_i) }

sensors = {}
beacons = []

input.each do |sx, sy, bx, by|
  d = (sx - bx).abs + (sy - by).abs
  sensors[[sx, sy]] = d
  beacons << [bx, by]
end


segments = sensors.map do |sen|
  sx, sy, d = sen.flatten
  [
    { m: 1, b: sy + d - sx, range: (sx-d)..(sx) },
    { m: 1, b: sy - d - sx, range: (sx)..(sx+d) },

    { m: -1, b: sy - d + sx, range: (sx-d)..(sx) },
    { m: -1, b: sy + d + sx, range: (sx)..(sx+d) },
  ]
end

intersection_points = []

segments.combination(2).each do |a_list, b_list|
  a_list.each do |a|
    b_list.each do |b|
      next if a[:m] == b[:m]
      x_overlap = b[:b] - a[:b] / (a[:m] - b[:m]).to_f
      y_overlap = (a[:m] * b[:b] - b[:m] * a[:b]) / (a[:m] - b[:m]).to_f

      intersection_points << [x_overlap, y_overlap]
    end
  end
end

require 'pry'
binding.pry
