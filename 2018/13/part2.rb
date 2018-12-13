#!/usr/bin/env ruby

$grid = {}
$carts = []

class Spot
  attr_reader :x, :y, :dir

  include Comparable

  def initialize(x, y, dir)
    @x = x
    @y = y
    @dir = dir
  end

  def <=>(other)
    [@y, @x] <=> [other.y, other.x]
  end
end

class Cart
  attr_accessor :spot, :direction

  include Comparable

  def initialize
    @decision_order = %i[left straight right]
  end

  def <=>(other)
    @spot <=> other.spot
  end

  def advance
    @spot = $grid[:"#{new_x}-#{new_y}"]

    if $carts.any? { |cart| !cart.eql?(self) && cart.spot == @spot }
      # crash!
      $carts.reject! { |cart| cart.spot == @spot }
      puts "Crash at #{@spot.x},#{@spot.y} - #{$carts.length} remaining"
      return
    end

    raise $carts.inspect if $carts.length == 1

    if @spot.dir == '\\'
      if @direction == :right
        @direction = :down
      elsif @direction == :up
        @direction = :left
      elsif @direction == :down
        @direction = :right
      else
        @direction = :up
      end
    elsif @spot.dir == '/'
      if @direction == :right
        @direction = :up
      elsif @direction == :up
        @direction = :right
      elsif @direction == :down
        @direction = :left
      else
        @direction = :down
      end
    elsif @spot.dir == '+'
      dir_decision
    end
  end

  def to_s
    "#{@spot.x},#{@spot.y} - #{@direction}"
  end

  private

  def dir_decision
    turn = @decision_order.shift
    @decision_order << turn

    if turn == :left
      case @direction
      when :up
        @direction = :left
      when :left
        @direction = :down
      when :down
        @direction = :right
      when :right
        @direction = :up
      end
    elsif turn == :right
      case @direction
      when :up
        @direction = :right
      when :left
        @direction = :up
      when :down
        @direction = :left
      when :right
        @direction = :down
      end
    end
  end

  def new_x
    if (direction == :right)
      @spot.x + 1
    elsif (direction == :left)
      @spot.x - 1
    else
      @spot.x
    end
  end

  def new_y
    if (direction == :up)
      @spot.y - 1
    elsif (direction == :down)
      @spot.y + 1
    else
      @spot.y
    end
  end
end

$max_x = 0
$max_y = 0

ARGF.each_with_index do |line, y|
  line.split('').each_with_index do |char, x|
    unless char == ' '
      direction = char
      direction = '-' if %w[< >].include?(char)
      direction = '|' if %w[v ^].include?(char)
      spot = Spot.new(x, y, direction)
      $grid[:"#{x}-#{y}"] = spot
    end

    if %w[< > v ^].include?(char)
      cart = Cart.new
      cart.spot = spot
      case char
      when '<'
        cart.direction = :left
      when '>'
        cart.direction = :right
      when '^'
        cart.direction = :up
      when 'v'
        cart.direction = :down
      end
      $carts.push(cart)
    end

    $max_x = [$max_x, x].max
  end
  $max_y = [$max_y, y + 1].max
end

def draw_grid
  ($max_y).times do |y|
    row = ""
    $max_x.times do |x|
      spot = $grid[:"#{x}-#{y}"]
      if spot.nil?
        row += ' '
      elsif $carts.any? { |cart| cart.spot === spot }
        row += "C"
      else
        row += spot.dir
      end
    end
    puts row
  end
end

while
  $carts.sort.each(&:advance)
end
