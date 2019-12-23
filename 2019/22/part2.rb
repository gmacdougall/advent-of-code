#!/usr/bin/env ruby

COMMANDS = File.read(ARGV.fetch(0)).strip.split("\n")

SIZE = 119315717514047

def compute(idx, step)
  if step == 0
    idx
  else
    command = COMMANDS[step - 1]
    if command.start_with?('deal into')
      return compute(SIZE - idx - 1, step - 1)
    elsif command.start_with?('cut')
      pos = idx + command.split(' ').last.to_i
      while pos < 0
        pos += SIZE
      end
      while pos >= SIZE
        pos -= SIZE
      end
      return compute(pos, step - 1)
    else
      increment = command.split(' ').last.to_i

      pos_inc = increment - (SIZE % increment)
      val_inc = (SIZE / increment) + 1

      pos = 0
      val = 0

      test = []
      increment.times do |n|
        test[pos] = val
        val += val_inc
        old_pos = pos
        pos = (pos + pos_inc) % increment
        if pos < old_pos
          val -= 1
        end
      end

      val = (test[1] * idx) % SIZE
      return compute(val, step - 1)
    end
  end
end

puts compute(2020, COMMANDS.length)
