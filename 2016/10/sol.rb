#! /usr/bin/env ruby
# frozen_string_literal: true

def solve(fname, return_early = false)
  bots = Hash.new {|hash, key| hash[key] = [] }
  output = Hash.new {|hash, key| hash[key] = [] }
  foo = {
    'bot' => bots,
    'output' => output,
  }
  instructions = {}

  File.read(fname).lines(chomp: true).each do |line|
    words = line.split
    if words[0] == 'value' && words[4] == 'bot'
      bots[words[5].to_i] << words[1].to_i
    elsif words[0] == 'bot'
      instructions[words[1].to_i] = [foo[words[5]][words[6].to_i], foo[words[10]][words[11].to_i]]
    else
      fail
    end
  end

  while (bot, values = bots.find { _2.size == 2 }) do
    low, high = values.sort
    instructions[bot][0] << low
    instructions[bot][1] << high
    bots[bot] = []

    return bot if low == 17 && high == 61 && return_early
  end

  output[0][0] * output[1][0] * output[2][0]
end

if File.exist?('input')
  puts "Part 1: #{solve('input', true)}"
  puts "Part 2: #{solve('input', false)}"
end
