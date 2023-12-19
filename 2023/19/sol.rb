#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require 'minitest/autorun'

class Workflow
  attr_reader :rules

  def initialize(name, rules, default)
    @rules = rules
    @default = default

    @@workflows ||= {}
    @@workflows[name] = self
  end

  def self.all = @@workflows
  def self.in = all[:in]
  def self.clear = @@workflows = {}

  def exits(r)
    return @default ? r.values.map(&:count).inject(1, :*) : 0 if rules.empty?

    rules.sum do |rule|
      val = rule.value
      val += 1 if rule.op == :>

      cat_range = r[rule.category]
      new_ranges = [cat_range.first, cat_range.end, val].sort.each_cons(2).map { |a, b| a...b }
      new_ranges.rotate! if rule.op == :>

      r[rule.category] = new_ranges[0]
      self.class.all[rule.to].exits(r.dup).tap { r[rule.category] = new_ranges[1] }
    end + self.class.all[@default].exits(r.dup)
  end

  def eval(rating)
    return @default if @rules.empty?

    rule = @rules.find { _1.match?(rating) }
    Workflow.all[rule&.to || @default].eval(rating)
  end
end

class Rule
  attr_reader :category, :op, :value, :to

  def initialize(category, op, value, to)
    @category = category.to_sym
    @op = op.to_sym
    @value = Integer(value)
    @to = to.to_sym
  end

  def match?(rating)
    rating[@category].public_send(@op, @value)
  end
end

def parse(data)
  workflows, ratings = data.split("\n\n")

  Workflow.new(:A, [], true)
  Workflow.new(:R, [], false)

  workflows = workflows.lines.each do |w|
    name, rules = w.match(/(\w+){(.*)}/).captures
    *rules, default = rules.split(',')
    rules = rules.map do |r|
      Rule.new(*r.match(/(\w)(.)(\d+):(\w+)/).captures)
    end
    Workflow.new(name.to_sym, rules, default.to_sym)
  end
  ratings.lines.map { _1.scan(/(\w)=(\d+)/).to_h.transform_keys(&:to_sym).transform_values(&:to_i) }
end

def part1(ratings)
  ratings.select { |r| Workflow.in.eval(r) }.flat_map(&:values).sum
end

def part2
  Workflow.in.exits({
    x: 1...4001,
    m: 1...4001,
    a: 1...4001,
    s: 1...4001,
  })
end

if File.exist?('input')
  input = parse(File.read('input'))
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2}"
  Workflow.clear
end

class MyTest < Minitest::Test
  def test_part1
    assert_equal(19114, part1(parse(File.read('sample'))))
    Workflow.clear
  end

  def test_part1
    parse(File.read('sample'))
    assert_equal(167409079868000, part2)
    Workflow.clear
  end
end
