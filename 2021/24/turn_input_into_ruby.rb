#! /usr/bin/env ruby
# frozen_string_literal: true

result = []
i = 0
current_w = nil
ARGF.each_line do |line|
  op, arg0, arg1 = line.split
  arg1 = current_w if arg1 == 'w'
  case op
  when 'inp'
    result << ''
    current_w = "INPUT[#{i}]"
    i += 1
  when 'add'
    result << "#{arg0} += #{arg1}"
  when 'mul'
    result << "#{arg0} *= #{arg1}"
  when 'div'
    result << "#{arg0} /= #{arg1}"
  when 'mod'
    result << "#{arg0} %= #{arg1}"
  when 'eql'
    # This is always flipped
    result << "#{arg0} = #{arg0} == #{arg1} ? 0 : 1"
  end
end

str = result.join("\n")
str.gsub!("x *= 0\nx += z\nx %= 26", 'x = z % 26')
str.gsub!("x *= 0\nx += z\nx %= 26", 'x = z % 26')
str.gsub!("x = x == 0 ? 0 : 1\n", '')
str.gsub!("z /= 1\n", '')
str.gsub!("x = x == w ? 1 : 0\nx = x == 0 ? 1 : 0", 'x = x == w ? 0 : 1')
str.gsub!("y *= 0\ny += 25\ny *= x\ny += 1\nz *= y", 'z *= (25 * x) + 1')
str.gsub!("y *= 0\ny += INPUT", 'y = INPUT')
str.gsub!("x = z % 26\nx +=", 'x = (z % 26) +')
str.gsub!("\ny +=", ' +')
str.gsub!(/y = (INPUT.*)/, 'z += (\1)')
str.gsub!("\ny *= x", ' * x')
str.gsub!("\nz += y", '')
puts "# frozen_string_literal: true\n\n"
puts 'z = 0'
puts 'INPUT = 98_765_432_999_999.digits'
puts str
puts 'puts z'
