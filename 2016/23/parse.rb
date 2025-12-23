File.read('input').lines(chomp: true).each do |line|
  words = line.split

  case words[0]
  when 'cpy'
    puts "#{words[2]} = #{words[1]}"
  when 'dec'
    puts "#{words[1]} -= 1"
  when 'inc'
    puts "#{words[1]} += 1"
  else
    puts line
  end
end
