#!/usr/bin/env ruby

ORIGINAL_MEM = File.read(ARGV.fetch(0)).strip.split(',').map(&:to_i)

def run(input)
  mem = Hash.new { 0 }
  ORIGINAL_MEM.each_with_index do |v, k|
    mem[k] = v
  end
  pos = 0
  relative_base = 0

  def set_mem(mem, addr, value)
    #puts "Setting #{addr} to #{value}"
    mem[addr] = value
  end

  output = []

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

result = {}
(402...522).each do |y|
  result[y] = {}
  (1066...1186).each do |x|
    result[y][x] = run([x,y]).first.to_i
  end
end

y_values = result.keys.first(20)
x_values = result.values.first.keys.first(20)

val = x_values.flat_map { |x| y_values.map { |y| [x, y] } }.select { |x,y| result[y+99][x] == 1 && result[y][x+99] == 1 && result[y][x] == 1 && result[y+99][x+99] == 1 }.first
puts val[0] * 10_000 + val[1]

def attempt1
  boundaries = [[0, 0], [nil, nil], [nil, nil], [nil, nil], [nil, nil], [2, 2], [nil, nil], [3, 3], [3, 3], [4, 4], [4, 4], [4, 5], [5, 5], [5, 6], [5, 6], [6, 7], [6, 7],
  [6, 8], [7, 8], [7, 9], [8, 9], [8, 9], [8, 10], [9, 10], [9, 11], [9, 11], [10, 12], [10, 12], [10, 13], [11, 13], [11, 14], [11, 14], [12, 15], [12, 15], [12, 16], [13, 16], [13, 17], [13, 17], [14, 18], [14, 18], [15, 19], [15, 19], [15, 19], [16, 20], [16, 20], [16, 21], [17, 21], [17, 22], [17, 22], [18, 23], [18, 23], [18, 24], [19, 24], [19, 25], [19, 25], [20, 26], [20, 26], [20, 27], [21, 27], [21, 28], [22, 28], [22, 29], [22, 29], [23, 29], [23, 30], [23,
  30], [24, 31], [24, 31], [24, 32], [25, 32], [25, 33], [25, 33], [26, 34], [26, 34], [26, 35], [27, 35], [27, 36], [27, 36], [28, 37], [28, 37], [29, 38], [29, 38], [29, 38], [30, 39], [30, 39], [30, 40], [31, 40], [31, 41], [31, 41], [32, 42], [32, 42], [32, 43], [33, 43], [33, 44], [33, 44], [34, 45], [34, 45], [34, 46], [35, 46], [35, 47], [36, 47], [36, 48], [36, 48], [37, 48], [37, 49], [37, 49], [38, 50], [38, 50], [38, 51], [39, 51], [39, 52], [39, 52], [40, 53], [40, 53], [40, 54], [41, 54], [41, 55], [42, 55], [42, 56], [42, 56], [43, 57], [43, 57], [43, 58], [44, 58], [44, 58], [44, 59], [45, 59], [45, 60], [45, 60], [46, 61], [46, 61], [46, 62], [47, 62], [47, 63], [47, 63], [48, 64], [48, 64], [49, 65], [49, 65], [49, 66], [50, 66], [50, 67], [50, 67], [51, 67],
  [51, 68], [51, 68], [52, 69], [52, 69], [52, 70], [53, 70]]


  left = [7, 18]
  left_increment = [2, 3, 3, 3, 3, 3, 3]
  left_pattern = left_increment.flat_map { |n| Array.new(n - 1, 0) + [1] } * 10_000

  right = [10, 22]
  right_increment = [2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3]
  right_pattern = right_increment.flat_map { |n| Array.new(n - 1, 0) + [1] } * 10_000

  104.times do
    left = [left[0] + left_pattern.shift, left[1] + 1]
  end

  while (right[0] - left[0] != 100)
    left = [left[0] + left_pattern.shift, left[1] + 1]
    right = [right[0] + right_pattern.shift, right[1] + 1]
  end


  puts left.inspect
  puts right.inspect

  puts right[1] * 10_000 + left[0]
end
