i=ARGF.map{_1.gsub /\s+/,''}
p i.sum{%w[_ BX CY AZ AX BY CZ CX AY BZ].find_index _1}
p i.sum{%w[_ BX CX AX AY BY CY CZ AZ BZ].find_index _1}
