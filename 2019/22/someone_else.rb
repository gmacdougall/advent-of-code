def simplify_at(steps, i, deck_size)
  return unless (op2, arg2 = steps[i + 1])
  op1, arg1 = steps[i]

  # Adjacent pairs of the same operation can be combined.
  # (dealwith by multiplication, cut by addition, reverse by elimination)
  #
  # Adjacent pairs of different operation can be transposed,
  # if applying an appropriate transformation to the pair
  # (see each pair for details on its appropriate transformation).
  #
  # Sift all dealwith to the front of the list,
  # and all reverse to the back of the list.
  #
  # Applied enough times, the list should end with just one of each operation.
  case [op1, op2]
  when [:dealwith, :dealwith]
    steps[i, 2] = [
      [:dealwith, (arg1 * arg2) % deck_size].freeze,
    ]
  when [:cut, :dealwith]
    steps[i, 2] = [
      [:dealwith, arg2].freeze,
      [:cut, (arg1 * arg2) % deck_size].freeze,
    ]
  when [:cut, :cut]
    steps[i, 2] = [
      [:cut, (arg1 + arg2) % deck_size].freeze,
    ]
  when [:reverse, :dealwith]
    steps[i, 2] = [
      [:dealwith, arg2].freeze,
      [:cut, -arg2 + 1].freeze,
      [:reverse].freeze,
    ]
  when [:reverse, :cut]
    steps[i, 2] = [
      [:cut, -arg2].freeze,
      [:reverse].freeze,
    ]
  when [:reverse, :reverse]
    steps[i, 2] = []
  end
end

def simplify(steps, deck_size)
  until steps.map(&:first).uniq == steps.map(&:first)
    steps.each_index { |i| simplify_at(steps, i, deck_size) }
  end
end

def modular_inverse(a, n)
  t, newt = [0, 1]
  r, newr = [n, a]
  until newr == 0
    q = r / newr
    t, newt = [newt, t - q * newt]
    r, newr = [newr, r - q * newr]
  end
  r > 1 ? nil : t % n
end

def apply(steps, cards)
  steps.each { |op, arg|
    case op
    when :dealwith
      inv = modular_inverse(arg, cards.size)
      cards = cards.each_index.map { |i| cards[(i * inv) % cards.size] }
    when :reverse
      cards.reverse!
    when :cut
      cards.rotate!(arg)
    else raise "unknown #{op} #{arg}"
    end
  }
  cards
end

verbose = false
input = File.read('input').strip.split("\n")

test = input.size < 40
deck_size = test ? 10 : 10007

steps = input.map { |a|
  words = a.split

  if words[0, 2] == ['deal', 'with']
    [:dealwith, Integer(words[-1])].freeze
  elsif words[0, 2] == ['deal', 'into']
    [:reverse].freeze
  elsif words[0] == 'cut'
    [:cut, Integer(words[-1])].freeze
  else raise "unknown #{words}"
  end
}

before_simp = steps.dup.freeze
simplify(steps, deck_size)
p steps if verbose

cards = (0...deck_size).to_a
cards1 = apply(before_simp, cards.dup)
cards2 = apply(steps, cards.dup)

raise "WRONG!!! UNSIMPLIFIED #{cards1} vs SIMPLIFIED #{cards2}" if cards1 != cards2

if test
  puts cards1.join(' ')
  exit 0
end

puts cards1.index(2019)

bits = {}
deck_size = 119315717514047

steps = before_simp.dup
simplify(steps, deck_size)

# Apply the shuffle repeatedly via exponentiation.
power = 1
num_shuffles = 101741582076661
until power > num_shuffles
  bits[power] = steps.dup.freeze
  power <<= 1
  steps.concat(steps)
  simplify(steps, deck_size)
end

relevant_bits = bits.keys.select { |k| num_shuffles & k != 0 }
raise "WRONG BITS!!! #{relevant_bits.sum} vs #{num_shuffles}" if relevant_bits.sum != num_shuffles
final = relevant_bits.flat_map(&bits)
simplify(final, deck_size)
p final if verbose

pos = 2020
final.reverse_each { |op, arg|
  case op
  when :dealwith
    pos = (pos * modular_inverse(arg, deck_size)) % deck_size
  when :reverse
    pos = deck_size - 1 - pos
  when :cut
    pos = (pos + arg) % deck_size
  else raise "Unknown #{op} #{arg}"
  end
}
p pos
