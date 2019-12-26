#!/usr/bin/env ruby

original_mem = File.read('input').strip.split(',').map(&:to_i)

hash_mem = Hash.new { 0 }
original_mem.each_with_index do |v, k|
  hash_mem[k] = v
end
MEM = hash_mem.freeze

def set_mem(mem, addr, value)
  #puts "Setting #{addr} to #{value}"
  mem[addr] = value
end

class Place
  attr_reader :x, :y, :name, :description, :contents

  def initialize(x, y, name, description, contents)
    @description = description
    @contents = contents
    @name = name
    @x = x
    @y = y
    @@all ||= {}
    @@all[[x, y]] = self
  end

  def self.all
    @@all
  end

  def north
    @@all[[x, y - 1]]
  end

  def south
    @@all[[x, y + 1]]
  end

  def east
    @@all[[x + 1, y]]
  end

  def west
    @@all[[x - 1, y]]
  end
end

def get_x_y(input)
  x = 0
  y = 0
  directions = input.split("\n")
  directions.each do |dir|
    case dir
    when "north"
      y += 1
    when "south"
      y -= 1
    when "east"
      x += 1
    when "west"
      x -= 1
    else
      fail
    end
  end
  [x, y]
end

def create_node(input, output)
  x, y = get_x_y(input)
  foo = output.split("\n\n\n").last.split("\n")
  idx = foo.find_index { |n| n.start_with?('==') }
  name = foo[idx]
  description = foo[idx + 1]
  idx = foo.find_index { |n| n == "Items here:" }
  items = []
  if idx
    idx += 1
    while foo[idx].length > 1
      items << foo[idx].gsub('- ', '')
      idx += 1
    end
  end
  Place.new(x, y, name, description, items)
end

def determine_inputs(original_input, output, x, y)
  lines = output.split("\n\n\n").last.split("\n")
  idx = lines.find_index { |s| s.end_with?("lead:") } + 1
  possible_directions = []
  while lines[idx].length > 1
    possible_directions << lines[idx].split(' ').last
    idx += 1
  end
  possible_directions.each do |dir|
    new_input = original_input + dir + "\n"
    unless Place.all[get_x_y(new_input)]
      run(new_input)
    end
  end
end

def run(original_input)
  input = original_input.bytes
  pos = 0
  relative_base = 0
  mem = MEM.dup
  output = ""

  while (mem[pos] != 99)
    full_opcode = mem[pos].to_s.rjust(5, '0').chars
    op = full_opcode.last(2).join.to_i

    p1 = mem[pos + 1].to_i
    address_p1 = p1
    p2 = mem[pos + 2].to_i
    p3 = mem[pos + 3].to_i
    address_p3 = p3

    if full_opcode[0] == '0'
      p3 = mem[p3]
    elsif full_opcode[0] == '2'
      address_p3 = relative_base + p3
      p3 = mem[relative_base + p3]
    end

    if full_opcode[1] == '0'
      p2 = mem[p2]
    elsif full_opcode[1] == '2'
      p2 = mem[relative_base + p2]
    end

    if full_opcode[2] == '0'
      p1 = mem[p1]
    elsif full_opcode[2] == '2'
      address_p1 = relative_base + p1
      p1 = mem[relative_base + p1]
    end

    case op
    when 1
      set_mem(mem, address_p3, p1 + p2)
      pos += 4
    when 2
      set_mem(mem, address_p3, p1 * p2)
      pos += 4
    when 3
      if input.empty?
        input = gets.bytes
      end
      set_mem(mem, address_p1, input.shift)
      pos += 2
    when 4
      print p1.chr
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
      set_mem(mem, address_p3, (p1 < p2 ? 1 : 0))
      pos += 4
    when 8
      set_mem(mem, address_p3, (p1 == p2 ? 1 : 0))
      pos += 4
    when 9
      relative_base += p1
      pos += 2
    else
      fail
    end
  end
end

program = """west
take fixed point
north
take sand
south
east
east
take asterisk
north
north
take hypercube
north
take coin
north
take easter egg
south
south
south
west
north
take spool of cat6
north
take shell
west
"""

drops = ["drop easter egg\n", "drop shell\n", "drop hypercube\n", "drop asterisk\n"]

run(program + drops.join + "north\n")
