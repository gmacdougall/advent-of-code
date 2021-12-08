#! /usr/bin/env ruby
# frozen_string_literal: true

TO_SEARCH_FOR = [2, 3, 4, 7].freeze

result = ARGF.each_line.sum do |line|
  line.split('|').last.split.count do |s|
    TO_SEARCH_FOR.include? s.length
  end
end
puts result
