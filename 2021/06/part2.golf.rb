# Run with ruby -F, part2.golf.rb input
a=[0]*9;gets.split.map{a[_1.hex]+=1};256.times{a.rotate!;a[6]+=a[8]};p a.sum
