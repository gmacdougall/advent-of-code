#! /usr/bin/env ruby

o = gets.chars
[4,14].map{ |n| p n + o.each_cons(n).find_index{ _1.uniq == _1 } }
