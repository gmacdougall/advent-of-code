OPERATIONS = {
  addr: -> (reg, a, b, c) { reg[c] = reg[a] + reg[b]; reg },
  addi: -> (reg, a, b, c) { reg[c] = reg[a] + b; reg },
  mulr: -> (reg, a, b, c) { reg[c] = reg[a] * reg[b]; reg },
  muli: -> (reg, a, b, c) { reg[c] = reg[a] * b; reg },
  banr: -> (reg, a, b, c) { reg[c] = reg[a] & reg[b]; reg },
  bani: -> (reg, a, b, c) { reg[c] = reg[a] & b; reg },
  borr: -> (reg, a, b, c) { reg[c] = reg[a] | reg[b]; reg },
  bori: -> (reg, a, b, c) { reg[c] = reg[a] | b; reg },
  setr: -> (reg, a, _, c) { reg[c] = reg[a]; reg },
  seti: -> (reg, a, _, c) { reg[c] = a; reg },
  gtir: -> (reg, a, b, c) { reg[c] = a > reg[b] ? 1 : 0; reg },
  gtri: -> (reg, a, b, c) { reg[c] = reg[a] > b ? 1 : 0; reg },
  gtrr: -> (reg, a, b, c) { reg[c] = reg[a] > reg[b] ? 1 : 0; reg },
  eqir: -> (reg, a, b, c) { reg[c] = a == reg[b] ? 1 : 0; reg },
  eqri: -> (reg, a, b, c) { reg[c] = reg[a] == b ? 1 : 0; reg },
  eqrr: -> (reg, a, b, c) { reg[c] = reg[a] == reg[b] ? 1 : 0; reg },
}

def parse(str)
  if str.include?('[')
    str.match(/\[(.*)\]/)[1].split(',')
  else
    str.split(' ')
  end.map(&:to_i)
end
