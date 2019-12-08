#!/usr/bin/env ruby

ORIGINAL_MEM = ARGF.read.strip.split(',').map(&:to_i).freeze

class Amplifier
  attr_reader :queue
  attr_accessor :next

  def initialize(phase_setting)
    @queue = Queue.new
    @phase_setting = phase_setting
    @queue << phase_setting
    run
  end

  def push(i)
    @queue.push(i)
  end

  def result
    @thread.join
    @thread[:output]
  end

  def run
    @thread = Thread.new do
      mem = ORIGINAL_MEM.dup
      pos = 0
      while (mem[pos] != 99)
        full_opcode = mem[pos].to_s.rjust(5, '0').chars
        op = full_opcode.last(2).join.to_i

        p1 = mem[pos + 1].to_i
        p2 = mem[pos + 2].to_i
        p3 = mem[pos + 3].to_i

        p3 = mem[p3] if full_opcode[0] == '0'
        p2 = mem[p2] if full_opcode[1] == '0'
        p1 = mem[p1] if full_opcode[2] == '0'

        case op
        when 1
          mem[mem[pos + 3]] = p1 + p2
          pos += 4
        when 2
          mem[mem[pos + 3]] = p1 * p2
          pos += 4
        when 3
          mem[mem[pos + 1]] = @queue.pop
          pos += 2
        when 4
          Thread.current[:output] = p1
          @next.queue.push(p1)
          pos += 2
        when 5
          if p1 != 0
            pos = p2
          else
            pos += 3
          end
        when 6
          if p1 == 0
            pos = p2
          else
            pos += 3
          end
        when 7
          if p1 < p2
            mem[mem[pos + 3]] = 1
          else
            mem[mem[pos + 3]] = 0
          end
          pos += 4
        when 8
          if p1 == p2
            mem[mem[pos + 3]] = 1
          else
            mem[mem[pos + 3]] = 0
          end
          pos += 4
        end
      end
    end
  end
end

result = (5..9).to_a.permutation.map do |permutation|
  amplifiers = permutation.map do |num|
    Amplifier.new(num)
  end

  amplifiers.each_with_index do |a, idx|
    a.next = amplifiers[(idx + 1) % amplifiers.length]
  end

  amplifiers.first.push(0)
  amplifiers.last.result
end
puts result.max
