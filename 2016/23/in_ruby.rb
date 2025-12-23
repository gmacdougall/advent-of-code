b = a
b -= 1
d = a
a = 0
loop do
  c = b
  loop do
    a += 1
    c -= 1
    break if c == 0
  end
  d -= 1
  break if d == 0
end
b -= 1
c = b
d = c
loop do
  d -= 1
  c += 1
  break if d == 0
end
tgl c
c = -16
jnz 1 c
c = 79
loop do
  jnz 74 d
  loop do
    a += 1
    d += 1
    break if d.zero?
  end
  c += 1
  break if c.zero?
end
