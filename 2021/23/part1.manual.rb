#! /usr/bin/env ruby
# frozen_string_literal: true

a = 1
b = 10
c = 100
d = 1000

puts [
  a * 5,
  a * 5,
  b * 5,
  d * 2,
#############
#AA.......D.#
###C#.#.#.###
  #B#B#D#C#
  #########
  c * 5,
  d * 6,
  d * 2,
#############
#AA...C.....#
###C#.#.#D###
  #B#B#.#D#
  #########
  c * 3,
  c * 6,
  b * 5,
  a * 3,
  a * 3,
].sum
