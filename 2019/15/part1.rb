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
      puts op.inspect
      fail
    end
  end
  output
end

N = 1
S = 2
W = 3
E = 4

dir_mod = {
  N => { x: 0, y: -1 },
  S => { x: 0, y: 1 },
  W => { x: -1, y: 0 },
  E => { x: 1, y: 0 },
}

x = y = 30
grid = 60.times.map do
  Array.new(60, '-')
end

grid[y][x] = '?'

shortest_path = {
  [y, x] => [],
}

oxygen = nil

while grid.flatten.include?('?')
  y = grid.find_index { |a| !a.nil? && a.include?('?') }
  x = grid[y].find_index('?')

  [N, S, E, W].each do |dir|
    grid[y] ||= []
    grid[y][x] = '.'

    new_x = x + dir_mod[dir][:x]
    new_y = y + dir_mod[dir][:y]

    case run(shortest_path[[y, x]] + [dir]).last
    when 0
      grid[new_y] ||= []
      grid[new_y][new_x] = '#'
    when 1
      grid[new_y][new_x] = '?' if grid[new_y][new_x] == '-'
      target_dest = [new_y, new_x]
      target = shortest_path[target_dest]
      new_path = shortest_path[[y, x]] + [dir]
      if target.nil? || target.length > new_path.length
        shortest_path[target_dest] = new_path
      end
    when 2
      oxygen = [new_y, new_x]
      grid[new_y][new_x] = '$' if grid[new_y][new_x] == '-'
      target_dest = [new_y, new_x]
      target = shortest_path[target_dest]
      new_path = shortest_path[[y, x]] + [dir]
      if target.nil? || target.length > new_path.length
        shortest_path[target_dest] = new_path
      end
    else
      fail
    end
  end
  grid.each do |row|
    puts row.map { |a| a.nil? ? '-' : a }.join unless row.nil?
  end
end

puts shortest_path[oxygen].length
