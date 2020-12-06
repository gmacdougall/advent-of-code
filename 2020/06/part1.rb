#!/usr/bin/env ruby

p ARGF.read.split("\n\n").map { |s| s.gsub("\n",'').chars.uniq }.flatten.count
