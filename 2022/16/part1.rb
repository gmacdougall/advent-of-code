#! /usr/bin/env ruby

require 'set'
require 'pry'

class Valve
  attr_reader :name, :rate, :to

  def initialize(name, rate, to)
    @name = name
    @rate = rate
    @to = to
    self.class.all[name] = self
  end

  def self.all
    @all ||= {}
  end
end

input = ARGF.map(&:strip).map { _1.gsub(',', '').split }.map do |_, name, _, _, rate, _, _, _, _, *to|
  [name, { rate: rate.scan(/\d+/)[0].to_i, to: }]
end.to_h
TOTAL = 30
MAX_FLOW = 30 * input.map { _2[:rate] }.sum

PATHS = {}
input.keys.each do |position|
  distances = {}
  to_check = Set.new
  to_check << [position, []]

  while props = to_check.first
    v, d = props
    to_check.delete(props)
    distances[v] = d
    input[v][:to].each do |n|
      to_check << [n, d + [n]] unless distances.has_key?(n)
    end
  end
  PATHS[position] = distances
end

non_empty = input.filter_map do |key, v|
  key if v[:rate] > 0
end

SIMPLE_PATHS = {}

(["AA"] + non_empty).each do |start|
  SIMPLE_PATHS[start] = {}
  non_empty.reject { _1 == start }.each do |finish|
    SIMPLE_PATHS[start][finish] = PATHS[start][finish].find_index(finish) + 1
  end
end

SIMPLE_PATHS.each do |name, distances|
  Valve.new(name, input[name][:rate], distances)
end

def dfs(path, time_remaining, flow)
  max = SIMPLE_PATHS[path[-1]].filter_map do |k, v|
    left = time_remaining - v - 1
    if !path.include?(k) && left > 0
      dfs(path + [k], left, flow + Valve.all[k].rate * left)
    else
      -1
    end
  end.max
  [flow, max].compact.max
end

result = dfs(['AA'], 30, 0)
p result
