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
    return 0 unless orbits
    orbits.ancestors + 1
  end
end

ARGF.each do |row|
  a, b = row.strip.split(')')
  SpaceObject.find(b).orbits = SpaceObject.find(a)
end

puts $objects.sum { |o| o.ancestors }
