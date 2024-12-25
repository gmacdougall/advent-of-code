#! /usr/bin/env ruby
# frozen_string_literal: true

require 'ruby-graphviz'

OP = {
  'AND' => :&,
  'OR' => :|,
  'XOR' => :^
}.freeze

def parse(fname)
  values, gates = File.read(fname).split("\n\n")
  values = values.lines.map { |line| line.strip.split(': ') }.map { [_1, _2.to_i] }.to_h
  gates = gates.lines.map { |line| line.split(' ') }.map { [_1, OP[_2], _3, _5] }
  [values, gates]
end

def part1(values, gates)
  gates.map(&:last).each { values[_1] = nil }

  while values.values.any?(&:nil?)
    gates.each do |v1, op, v2, to|
      next if values[v1].nil? || values[v2].nil? || !values[to].nil?

      values[to] = values[v1].public_send(op, values[v2])
    end
  end

  result = 0
  values.each do |key, val|
    next unless key.start_with?('z')

    idx = key[1..].to_i
    result |= val * 2**idx
  end
  result
end

# NOTE: Hackiness ahead
def graph_part2(_, gates)
  g = GraphViz.new(:G, type: :graph)
  gate_map = gates.flat_map { |a, _, c, d| [a, c, d] }.uniq.sort.map do |val|
    [val, g.add_nodes(val)]
  end.to_h

  gates.each do |p1, op, p2, dest|
    gate = g.add_nodes(op.to_s)
    g.add_edges(gate_map[p1], gate)
    g.add_edges(gate_map[p2], gate)
    g.add_edges(gate, dest)
  end
  g.output(svg: 'graph.svg')
end

if File.exist?('input')
  puts "Part 1: #{part1(*parse('input'))}"
  puts "Part 2: #{graph_part2(*parse('input'))}"
end

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_part1
    assert_equal(4, part1(*parse('sample')))
  end
end
