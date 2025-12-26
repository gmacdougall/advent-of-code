puts 'a = b = 0'

File.read('input').lines(chomp: true).each do |line|
  words = line.split

  case words[0]
  when 'hlf'
    puts "#{words[1]} /= 2"
  when 'tpl'
    puts "#{words[1]} *= 3"
  when 'inc'
    puts "#{words[1]} += 1"
  else
    puts line
  end
end
