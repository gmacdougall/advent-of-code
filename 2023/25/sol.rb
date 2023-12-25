#! /usr/bin/env ruby
# frozen_string_literal: true

require 'nokogiri'
require 'pry'
require 'ruby-graphviz'

class Component
  attr_reader :name, :links
  attr_accessor :visited

  def initialize(name)
    @name = name
    @links = []
    @visited = false
    @@all ||= {}
    @@all[name] = self
  end

  def self.get(name) = @@all[name] || new(name)
  def self.clear = @@all = {}
  def self.values = @values ||= @@all.values
  def self.all_links = @all_links ||= values.flat_map { |v| v.links.map { [_1, v.name].sort } }.uniq
  def self.reset = @values.each { _1.visited = false }

  def inspect = "<Component name=#{@name} visited=#{visited} links=#{@links.join(',')}>"
  def adjacent = @adjacent ||= @links.map { @@all[_1] }

  def link(others)
    others.each do |other_name|
      other = self.class.get(other_name)
      other.links << self.name
      @links << other_name
    end
  end

  def visit(exclude)
    @visited = true
    adjacent.each do |node|
      next if node.visited
      next if exclude.include?([@name, node.name].sort)
      node.visit(exclude)
    end
  end

  def self.graph
    g = GraphViz.new( :G, :type => :graph )
    node_map = values.map do |val|
      [val.name, g.add_nodes(val.name)]
    end.to_h
    all_links.each do |n1, n2|
      g.add_edges(node_map[n1], node_map[n2])
    end
    g.output(svg: 'graph.svg')
  end

  def self.solve
    graph unless File.exist?('graph.svg')
    svg = File.read('graph.svg')
    doc = Nokogiri::XML.parse(svg)
    minmax = doc.css('.edge').map do |edge|
      [
        edge.css('title').text,
        Range.new(*edge.css('path').attr('d').value.gsub('M', '').gsub('C', ' ').split(' ').map { _1.split(',').first }.map(&:to_i).minmax),
      ]
    end

    (minmax.map { _1.last.min }.sort[3]..).each do |x|
      if minmax.map(&:last).count { _1.cover?(x) } == 3
        exclude = minmax.select { |text, range| range.cover?(x) }.map(&:first).map { _1.split('--').sort }
        values.sample.visit(exclude)
        return values.count(&:visited) * values.count { !_1.visited }
      end
    end
  end
end


def parse(file)
  file.each_line do |line|
    name, others = line.strip.split(': ')
    Component.get(name).link(others.split(' '))
  end
end

if File.exist?('input')
  Component.clear
  parse(File.read('input'))
  puts "Part 1: #{Component.solve}"
end

