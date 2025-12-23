a = b = 1
c = 1
d = 26
if c > 0
  c = 7
  while c > 0
    d += 1
    c -= 1
  end
end
while d > 0
  c = a
  while b > 0
    a += 1
    b -= 1
  end
  b = c
  d -= 1
end
c = 16
while c > 0
  d = 17
  while d > 0
    a += 1
    d -= 1
  end
  c -= 1
end

puts a
