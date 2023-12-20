#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'minitest/autorun'

def log(str)
  puts str if ENV['LOG']
end

class Module
  attr_reader :name, :dest

  def initialize(name, dest)
    @@all ||= {}
    @@all[name] = self
    @@queue = []
    @@pulses_sent = { true => 0, false => 0 }
    @name = name
    @dest = dest
  end

  def self.connect_inputs
    @@all.values.each do |mod|
      mod.dest.each do |dest|
        @@all[dest].connect_input(mod.name)
      end
    end
  end

  def self.reset
    @@all = {}
    @@pulses_sent = { true => 0, false => 0 }
  end

  def self.total
    @@pulses_sent.values.inject(1, :*)
  end

  def path_to_rx
    @path_to_rx ||= @@all.values.find { _1.dest.include?('rx') }&.name
  end

  def dispatch(high)
    @dest.each { @@queue << [self, _1, high] }
    while !@@queue.empty?
      source, dest, pulse = @@queue.shift
      log("#{source.name} -#{pulse ? 'high' : 'low'}-> #{dest}")
      @@pulses_sent[pulse] += 1
      dest = @@all[dest]
      dest.pulse(source.name, pulse)
    end
  end

  def connect_input(mod)
    # no-op
  end

  def pulse(_, _)
    # no-op
  end
end

class FlipFlop < Module
  def initialize(name, dest)
    super
    @state = false
  end

  def pulse(_, high)
    return if high
    @state = !@state
    dispatch @state
  end
end

class Conjunction < Module
  def initialize(name, dest)
    super
    @memory = Hash.new(false)
  end

  def pulse(name, high)
    @memory[name] = high
    if @dest.include?(path_to_rx) && !high
      $iterations[@name] = $presses
    end
    dispatch !@memory.values.all?
  end

  def connect_input(mod)
    @memory[mod] = false
  end
end

class Broadcast < Module
  def initialize(dest) = super('broadcast', dest)
  def pulse(_, high) = dispatch(high)
end

class Button < Module
  def initialize = super('button', ['broadcast'])
  def push = dispatch(false)
end

def parse(file)
  Module.reset
  file.each_line do |line|
    id, dest = line.strip.split(' -> ')
    dest = dest.split(', ')

    if id == 'broadcaster'
      Broadcast.new dest
    else
      type = id[0]
      name = id[1..]
      if type == '%'
        FlipFlop.new name, dest
      else
        Conjunction.new name, dest
      end
    end
  end

  Module.new('output', [])
  rx = Module.new('rx', [])
  Module.connect_inputs
  [Button.new, rx]
end

def part1(file)
  button, _ = parse(file)
  1000.times { button.push }
  Module.total
end

def part2(file)
  button, rx = parse(file)
  $presses = 0
  $iterations = {}
  while $iterations.count != 4
    $presses += 1
    button.push
  end
  $iterations.values.inject(1, :lcm)
end

if File.exist?('input')
  input = File.read('input')
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2(input)}"
end

class MyTest < Minitest::Test
  def test_part1_sample1
    assert_equal(32000000, part1(File.read('sample1')))
  end

  def test_part1_sample2
    assert_equal(11687500, part1(File.read('sample2')))
  end
end
