#! /usr/bin/env ruby
# frozen_string_literal: true

def part1
  requirements = File.read('requirements').lines(chomp: true).map { _1.split(': ') }.to_h

  File.read('input').lines(chomp: true).each do |line|
    caps = line.match(/Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)/).captures
    sue = caps.shift
    gifts = caps.each_slice(2).to_h

    return sue if gifts.all? { |gift, num| requirements[gift] == num }
  end
end

def part2
  requirements = File.read('requirements').lines(chomp: true).map { _1.split(': ') }.to_h

  File.read('input').lines(chomp: true).each do |line|
    caps = line.match(/Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)/).captures
    sue = caps.shift
    gifts = caps.each_slice(2).to_h

    return sue if gifts.all? do |gift, num|
      case gift
      when 'cats', 'trees'
        requirements[gift].to_i < num.to_i
      when 'pomeranians', 'goldfish'
        requirements[gift].to_i > num.to_i
      else
        requirements[gift] == num
      end
    end
  end
end

if File.exist?('input')
  puts "Part 1: #{part1}"
  puts "Part 2: #{part2}"
end
