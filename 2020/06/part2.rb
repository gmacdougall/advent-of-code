#!/usr/bin/env ruby

p ARGF.read.split("\n\n").sum { |s| s.split("\n").map(&:chars).inject(:&).length }
