#!/usr/bin/env ruby

PATTERN = [0, 1, 0, -1].freeze

input_signal = '59791875142707344554745984624833270124746225787022156176259864082972613206097260696475359886661459314067969858521185244807128606896674972341093111690401527976891268108040443281821862422244152800144859031661510297789792278726877676645835805097902853584093615895099152578276185267316851163313487136731134073054989870018294373731775466754420075119913101001966739563592696702233028356328979384389178001923889641041703308599918672055860556825287836987992883550004999016194930620165247185883506733712391462975446192414198344745434022955974228926237100271949068464343172968939069550036969073411905889066207300644632441054836725463178144030305115977951503567'

100.times do
  input_signal = input_signal.chars.each_with_index.map do |_, idx|
    pattern = (([0] * idx) + (PATTERN.flat_map { |p| Array.new(idx + 1, p) } * 200)[(idx+1)..-1]).first(input_signal.length)
    input_signal.chars.inject(0) do |sum, n|
      sum += n.to_i * pattern.shift
    end.abs.digits.first.to_s
  end.join
  puts input_signal
end

puts input_signal.inspect