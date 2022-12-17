#! /usr/bin/env ruby

require 'set'

INPUT = ARGF.map(&:strip).map { _1.gsub(',', '').split }.map do |_, name, _, _, rate, _, _, _, _, *to|
  [name, { rate: rate.scan(/\d+/)[0].to_i, to: }]
end.to_h

PATHS = INPUT.keys.map do |position|
  distances = {}
  to_check = Set.new
  to_check << [position, []]

  while props = to_check.first
    v, d = props
    to_check.delete(props)
    distances[v] = d
    INPUT[v][:to].each do |n|
      to_check << [n, d + [n]] unless distances.has_key?(n)
    end
  end
  [position, distances]
end.to_h

non_empty = INPUT.filter_map { |key, v| key if v[:rate] > 0 }

SIMPLE_PATHS = {}
(["AA"] + non_empty).each do |start|
  SIMPLE_PATHS[start] = {}
  non_empty.reject { _1 == start }.each do |finish|
    SIMPLE_PATHS[start][finish] = PATHS[start][finish].find_index(finish) + 1
  end
end

BEST_SO_FAR = {}
TOO_SLOW_THRESHOLD = 100

def dfs(me, elephant, me_time, elephant_time, flow)
  if (BEST_SO_FAR[me_time + elephant_time] || 0) - TOO_SLOW_THRESHOLD > flow
    # Too slow
    return flow
  else
    BEST_SO_FAR[me_time + elephant_time] = flow
  end

  max = if (me_time > elephant_time)
    SIMPLE_PATHS[me[-1]].filter_map do |k, v|
      left = me_time - v - 1
      if !me.include?(k) && !elephant.include?(k) && left > 0
        dfs(me + [k], elephant, left, elephant_time, flow + INPUT[k][:rate] * left)
      end
    end.max
  else
    SIMPLE_PATHS[elephant[-1]].filter_map do |k, v|
      left = elephant_time - v - 1
      if !me.include?(k) && !elephant.include?(k) && left > 0
        dfs(me, elephant + [k], me_time, left, flow + INPUT[k][:rate] * left)
      end
    end.max
  end
  max && max > flow ? max : flow
end

result = dfs(['AA'], ['AA'], 26, 26, 0)
p result
