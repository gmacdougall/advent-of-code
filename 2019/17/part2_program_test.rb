#!/usr/bin/env ruby

map = File.read(ARGV.fetch(0)).strip.split("\n").map(&:chars)

robot_y = 10
robot_x = 54

$vel_x = 0
$vel_y = 1
$dir = -1

def turn(val)
  if (val == 'L')
    $dir -= 1
  else
    $dir += 1
  end
  $vel_x = Math.cos($dir * Math::PI / 2).round
  $vel_y = Math.sin($dir * Math::PI / 2).round
end

func_a = 'R,6,L,10,R,8,R,8'
func_b = 'R,12,L,10,R,6,L,10'
func_c = 'R,12,L,8,L,10'

program1 = "#{func_a},#{func_c},#{func_a},#{func_b},#{func_c},#{func_b},#{func_a},#{func_c},#{func_a},#{func_b}"
program2 = 'R,6,L,10,R,8,R,8,R,12,L,8,L,10,R,6,L,10,R,8,R,8,R,12,L,10,R,6,L,10,' \
  'R,12,L,8,L,10,R,12,L,10,R,6,L,10,R,6,L,10,R,8,R,8,R,12,L,8,L,10,R,6,L,10,' \
  'R,8,R,8,R,12,L,10,R,6,L,10'

program2.split(',').each_slice(2) do |dir, distance|
  turn(dir)
  distance.to_i.times do
    robot_y += $vel_y
    robot_x += $vel_x
    if map[robot_y][robot_x] == '.'
      puts "#{robot_x},#{robot_y}"
      map.each { |row| puts row.join }
      fail
    end
    map[robot_y][robot_x] = '@'
  end
end

map.each { |row| puts row.join }

puts func_a.length
