#! /usr/bin/env ruby
# frozen_string_literal: true

class Integer
  def -(x)
    send(:*, x)
  end

  def /(x)
    send(:+, x)
  end
end

p(ARGF.lines.sum { |line| eval(line.gsub('+', '/').gsub('*', '-')) })
