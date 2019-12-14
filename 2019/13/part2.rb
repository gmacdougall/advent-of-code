#!/usr/bin/env ruby

ORIGINAL_MEM = File.read(ARGV.fetch(0)).strip.split(',').map(&:to_i)

def run(input)
  input = input.dup
  mem = Hash.new { 0 }
  ORIGINAL_MEM.each_with_index do |v, k|
    mem[k] = v
  end
  pos = 0
  relative_base = 0

  mem[0] = 2 # Free Play

  output = []

  def set_mem(mem, addr, value)
    #puts "Setting #{addr} to #{value}"
    mem[addr] = value
  end

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
      set_mem(mem, address_p1, input.shift)
      pos += 2
    when 4
      output << p1
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
  output
end

input = Array.new(10_000, 0)

def display(value)
  case value
  when 0
    ' '
  when 1
    '#'
  when 2
    'x'
  when 3
    '_'
  when 4
    '0'
  end
end

score = 0

while (score == 0)
  paddle_position = 22 + input.sum
  output = run(input)

  grid = []
  ball_result = []

  steps = 0
  output.each_slice(3) do |x, y, value|
    grid[y] ||= []
    grid[y][x] = display(value)

    if value == 4
      steps += 1
      ball_result << [x, steps] if y == 20
    end

    if x == -1 && y == 0
      score = value
    end
  end

  puts grid.flatten.select { |a| a == 'x' }.length

  target = ball_result.last.first
  needs_to_move = target - paddle_position
  ending_time = ball_result.last.last

  Range.new(ending_time - needs_to_move.abs, ending_time - 1).each do |i|
    paddle_position += needs_to_move / needs_to_move.abs
    input[i] = needs_to_move / needs_to_move.abs
  end
end

puts score.inspect
