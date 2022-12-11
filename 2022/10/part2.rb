#! /usr/bin/env ruby

class ClockCircuit
  WIDTH = 40

  def initialize
    @x = 1
    @cycle = 0
    @output = []
  end

  def noop
    tick
  end

  def addx(x)
    2.times { tick }
    @x += x.to_i
  end

  def to_s
    @output.map { _1 ? '█' : ' ' }.each_slice(WIDTH).map(&:join).join("\n")
  end

  private

  def tick
    @output.push ((@cycle % WIDTH) - @x).abs <= 1
    @cycle += 1
  end
end

cc = ClockCircuit.new

ARGF.map { _1.strip.split }.each do |command, *rest|
  cc.public_send(command.to_sym, *rest)
end

puts cc
