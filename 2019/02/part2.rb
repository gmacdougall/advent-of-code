#!/usr/bin/env ruby

original_code = ARGF.read.strip.split(',').map(&:to_i)

(0..99).each do |noun|
  (0..99).each do |verb|
    code = original_code.dup
    pos = 0

    code[1] = noun
    code[2] = verb

    while (code[pos] != 99)
      op = code[pos]
      p1 = code[pos + 1]
      p2 = code[pos + 2]
      store = code[pos + 3]

      if op == 1
        code[store] = code[p1] + code[p2]
      elsif code[pos] == 2
        code[store] = code[p1] * code[p2]
      else
        fail
      end
      pos += 4
    end
    puts "#{code[0]}: #{noun},#{verb}"
    if code[0] == 19690720
      puts '=' * 100
      puts noun * 100 + verb
      exit
    end
  end
end
