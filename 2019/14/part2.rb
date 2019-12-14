#!/usr/bin/env ruby

class Reaction
  attr_reader :inputs, :output

  def initialize(inputs, output)
    @inputs = inputs
    @output = output
  end

  def required_inputs(quantity_of_output)
    multiplier = (quantity_of_output.to_f / output.values.last).ceil
    inputs.map do |k, v|
      multiplier = (quantity_of_output.to_f / output.values.last).ceil
      [k, v * multiplier]
    end
  end

  def amount_output(quantity_of_output)
    multiplier = (quantity_of_output.to_f / output.values.last).ceil
    output.values.first * multiplier
  end

  def output_type
    output.keys.first
  end

  def comes_from_ore?
    inputs.keys.any? { |k| k == 'ORE' }
  end
end

reactions = File.read(ARGV.fetch(0)).strip.split("\n").map do |r|
  r.split(' => ')
end.map do |input, output|
  Reaction.new(
    Hash[input.split(',').map(&:strip).map do |i|
      i.split(' ').tap { |x| x[0] = x[0].to_i }.reverse
    end],
    Hash[[output.split(' ').reverse.tap { |x| x[1] = x[1].to_i }]]
  )
end

# I could bisect this properly, but that took too long...
(4_052_500..5_000_000).each do |n|
  requirements = Hash.new(0)
  requirements['FUEL'] = n

  while true
    needed = requirements.select { |k, v| v > 0 && k != 'ORE' }
    to_transform = needed.reject { |req| reactions.find { |r| r.output_type == req }&.comes_from_ore? }.first
    to_transform ||= needed.first
    break unless to_transform
    to_transform = to_transform.first

    reaction = reactions.find { |r| r.output_type == to_transform }

    required = requirements[to_transform]
    required_inputs = reaction.required_inputs(required)
    requirements[to_transform] -= reaction.amount_output(required)

    required_inputs.each do |input, quantity|
      requirements[input] += quantity
    end
  end

  puts n, requirements['ORE']
  break if requirements['ORE'] > 1_000_000_000_000
end
