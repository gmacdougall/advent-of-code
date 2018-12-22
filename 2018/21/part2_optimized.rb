#!/usr/bin/env ruby

reg = Array.new(6, 00)
reg[0] = 0

def print(reg)
  puts reg.inspect
end

reg5values = []

while true
  reg[5] = 123                  # seti 123 0 5
  reg[5] = 75                   # bani 5 456 5
  reg[5] = 1                    # eqri 5 72 5
  break if reg[5] == 1          # addr 5 1 1
end                             # seti 0 0 1 -- Infinite Loop
reg[5] = 0                      # seti 0 9 5

while true
  reg[2] = 65_536 | reg[5]        # bori 5 65536 2
  reg[5] = 7_571_367              # seti 7571367 9 5

  while true
    reg[4] = reg[2] & 255         # bani 2 255 4
    reg[5] = reg[4] + reg[5]      # addr 5 4 5
    reg[5] = 16_777_215 & reg[5]  # bani 5 16777215 5
    reg[5] *= 65_899              # muli 5 65899 5
    reg[5] = 16_777_215 & reg[5]  # bani 5 16777215 5

    break if 256 > reg[2]

    reg[4] = 0                        # seti 0 2 4
    while true
      reg[3] = reg[4] + 1               # addi 4 1 3
      reg[3] *= 256                     # muli 3 256 3
      break if reg[3] > reg[2]        # gtrr 3 2 3
      reg[4] += 1                     # addi 4 1 4
    end

    reg[2] = reg[4]             #  setr 4 6 2
  end
  if reg5values.include?(reg[5])
    puts reg5values.last
    exit
  else
    reg5values << reg[5]
    puts reg[5]
  end
  break if reg[5] == reg[0]
end

print reg

