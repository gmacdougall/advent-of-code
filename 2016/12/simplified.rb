a = b = 1
33.times do
  c = a
  a += b
  b = c
end
16.times do
  a += 17
end

puts a
