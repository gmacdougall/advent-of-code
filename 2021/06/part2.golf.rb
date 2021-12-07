# Run with ruby -F, part2.golf.rb input
a=[0]*9;$<.read.split.map{a[_1.to_i]+=1};256.times{a.rotate!;a[6]+=a[8]};p a.sum
