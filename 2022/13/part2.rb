#! /usr/bin/env ruby

def compare(a, b)
  if a.is_a?(Integer) && b.is_a?(Integer)
    return nil if a == b
    return a < b
  elsif a.is_a?(Array) && b.is_a?(Array)
    a.each_index do |idx|
      break if !b[idx]
      res = compare(a[idx], b[idx])
      return res unless res.nil?
    end
    return nil if a.length == b.length
    return a.length < b.length
  elsif a.is_a?(Array) && b.is_a?(Integer)
    return compare(a, [b])
  elsif a.is_a?(Integer) && b.is_a?(Array)
    return compare([a], b)
  end
end

class Packet
  include Comparable

  attr_reader :stuff

  def initialize(stuff)
    @stuff = stuff
  end

  def <=>(b)
    compare(self.stuff, b.stuff) ? -1 : 1
  end
end

divider_packets = [
  Packet.new([[2]]),
  Packet.new([[6]])
]

input = ARGF.each_line.map(&:strip).reject(&:empty?).map do |i|
  Packet.new(eval(i))
end + divider_packets

puts (input.sort.find_index(divider_packets.first) + 1) * (input.sort.find_index(divider_packets.last) + 1)
