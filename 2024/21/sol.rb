#! /usr/bin/env ruby
# frozen_string_literal: true

require 'rainbow/refinement'
using Rainbow

class Keypad
  def initialize
    reset
    @memo = {}
  end

  attr_reader :cx, :cy, :result

  def key_pos_invert = @key_pos_invert ||= key_pos.invert

  def reset
    @result = []
    @current = 'A'
    @cx = 2
    @cy = 3
  end

  def dump(key)
    puts "Pressing #{key} on #{@id}"
    key_pos.values.map(&:last).uniq.sort.each do |y|
      key_pos.values.map(&:first).uniq.sort.each do |x|
        color = x == @cx && y == @cy ? :red : :white
        print((key_pos.invert[[x, y]] || ' ').send(color))
      end
      puts ''
    end
    puts ''
  end

  def press(key)
    case key
    when '<'
      @cx -= 1
    when '>'
      @cx += 1
    when '^'
      @cy -= 1
    when 'v'
      @cy += 1
    when 'A'
      if @other_keypad
        @other_keypad.press key_pos.invert[[@cx, @cy]]
      else
        @result << key_pos.invert[[@cx, @cy]]
      end
    else
      raise
    end
  end

  def predict(key)
    kx, ky = key_pos[key]

    dx = (kx - cx)
    dy = (ky - cy)

    x_moves = dx.abs.times.map do
      dx.positive? ? '>' : '<'
    end

    y_moves = dy.abs.times.map do
      dy.positive? ? 'v' : '^'
    end

    moves = if key_pos_invert[[kx, @cy]] && dx.negative?
              x_moves + y_moves
            elsif key_pos_invert[[@cx, ky]]
              y_moves + x_moves
            else
              x_moves + y_moves
            end
    moves << 'A'

    @current = key
    @cx = kx
    @cy = ky

    raise unless key_pos.invert[[@cx, @cy]]

    moves
  end

  def type(str)
    return @memo[str] if @memo.key?(str)

    reset
    result = str.chars.map { predict _1 }.flatten.join
    @memo[str] = result
    result
  end
end

class NumericKeypad < Keypad
  KEY_POS = {
    '7' => [0, 0],
    '8' => [1, 0],
    '9' => [2, 0],
    '4' => [0, 1],
    '5' => [1, 1],
    '6' => [2, 1],
    '1' => [0, 2],
    '2' => [1, 2],
    '3' => [2, 2],
    '0' => [1, 3],
    'A' => [2, 3]
  }.freeze

  def initialize
    super
    @id = 'nk '
    @panic_row = 3
  end

  def key_pos = KEY_POS
end

class RobotKeypad < Keypad
  KEY_POS = {
    '^' => [1, 0],
    'A' => [2, 0],
    '<' => [0, 1],
    'v' => [1, 1],
    '>' => [2, 1]
  }.freeze

  def initialize(id, other_keypad)
    super()
    @id = id
    reset
    @other_keypad = other_keypad
    @panic_row = 0
  end

  def reset
    @result = []
    @cx = 2
    @cy = 0
  end

  def key_pos = KEY_POS

  def type(str)
    return @memo[str] if @memo.key?(str)

    result = super @other_keypad.type(str)
    @memo[str] = result
    result
  end
end

def parse(fname) = File.read(fname).lines.map(&:strip)

def part1(input)
  input.sum do |str|
    nk = NumericKeypad.new
    rk1 = RobotKeypad.new('rk01', nk)
    rk2 = RobotKeypad.new('rk02', rk1)
    result = rk2.type(str)
    puts "#{result.size} * #{str.to_i}"
    result.size * str.to_i
  end
end

def part2(input)
  input.sum do |str|
    nk = NumericKeypad.new
    keypads = [nk]
    12.times do |n|
      kp = RobotKeypad.new(n, keypads.last)
      keypads << kp
    end
    result = keypads.last.type(str)
    puts "#{result.size} * #{str.to_i}"
    result.size * str.to_i
  end
end

puts "Part 1: #{part1(parse('input'))}"
puts "Part 2: #{part2(parse('input'))}"

require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_confirm
    nk = NumericKeypad.new
    rk1 = RobotKeypad.new('rk01', nk)
    rk2 = RobotKeypad.new('rk02', rk1)
    'v<A<AA>>^AAvA<^A>AAvA^Av<A>^A<A>Av<A>^A<A>Av<A<A>>^AAvA<^A>A'.chars.each { rk2.press _1 }
    assert_equal('456A', nk.result.join)
  end

  def test_numeric_keypad
    nk = NumericKeypad.new
    result = nk.type('029A')

    assert_equal('<A^A^^>AvvvA', result)
  end

  def test_one_robot_keypad
    nk = NumericKeypad.new
    rk1 = RobotKeypad.new('rk01', nk)
    assert_equal('v<<A>>^A<A>AvA<^AA>A<vAAA>^A'.size, rk1.type('029A').size)
  end

  def test_two_robot_keypad
    two_robots('<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A', '029A')
  end

  def two_robots(expected, str)
    nk = NumericKeypad.new
    rk1 = RobotKeypad.new('rk01', nk)
    rk2 = RobotKeypad.new('rk02', rk1)
    result = rk2.type(str)
    assert_equal(expected.size, result.size)
  end

  def test_980a
    two_robots('<v<A>>^AAAvA^A<vA<AA>>^AvAA<^A>A<v<A>A>^AAAvA<^A>A<vA>^A<A>A', '980A')
  end

  def test_179a
    two_robots('<v<A>>^A<vA<A>>^AAvAA<^A>A<v<A>>^AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A', '179A')
  end

  def test_456a
    two_robots('<v<A>>^AA<vA<A>>^AAvAA<^A>A<vA>^A<A>A<vA>^A<A>A<v<A>A>^AAvA<^A>A', '456A')
  end

  def test_379a
    two_robots('<v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A', '379A')
  end

  def test_part1
    assert_equal(126_384, part1(parse('sample')))
  end
end
