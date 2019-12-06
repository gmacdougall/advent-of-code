#!/usr/bin/env ruby

$objects = []

class SpaceObject
  attr_reader :name
  attr_accessor :orbits

  def initialize(name)
    @name = name
    $objects << self
  end

  def self.find(name)
    $objects.find { |obj| obj.name == name } || new(name)
  end

  def ancestors
    return [] unless orbits
    [orbits] + orbits.ancestors
  end

  def inspect
    name
  end

  def to_s
    name
  end
end

ARGF.each do |row|
  a, b = row.strip.split(')')
  SpaceObject.find(b).orbits = SpaceObject.find(a)
end

you_ancestors = SpaceObject.find('YOU').ancestors
san_ancestors = SpaceObject.find('SAN').ancestors

common = (you_ancestors & san_ancestors).first

puts you_ancestors.find_index(common) + san_ancestors.find_index(common)
