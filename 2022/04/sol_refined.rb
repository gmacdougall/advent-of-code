#! /usr/bin/env ruby

i=ARGF.map{_1.split(?,).map{|s|Range.new(*s.split(?-).map(&:to_i))}}
p i.count{_1.cover?(_2)||_2.cover?(_1)}
p i.count{(_1.to_a&_2.to_a).any?}
