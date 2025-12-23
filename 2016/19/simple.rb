size = 3_014_603
arr = Array.new(size) { it + 1};
idx = 0
(size - 1).times do |n|
  puts n if n % 1000 == 0
  to_delete = (idx + (arr.length / 2)) % arr.length
  arr.delete_at(to_delete)
  idx -= 1 if to_delete < idx
  idx = (idx + 1) % arr.length
end
puts arr.first
