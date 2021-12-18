# frozen_string_literal: true

# https://adventofcode.com/2021/day/18
class SnailfishNumber
  attr_reader :data

  def initialize(data)
    @data = data
    reduce
  end

  def self.parse(str)
    new(eval(str)) # rubocop:disable Security/Eval
  end

  def +(other)
    self.class.new([@data, other.data])
  end

  def magnitude(d = @data)
    return d if d.is_a?(Integer)

    (3 * magnitude(d[0])) + (2 * magnitude(d[1]))
  end

  def to_s
    @data.inspect.gsub(' ', '')
  end

  private

  def reduce
    loop do
      @numbers = @data.flatten
      result = explode2(explode(@data))

      if result == @data
        result = split(result)
        break if result == @data
      end

      @data = result
    end
  end

  def explode2(subset, level = 0)
    @idx = 0 if level.zero?
    if subset.respond_to?(:each)
      subset.map { |d| explode2(d, level + 1) }
    else
      @numbers[@idx].tap { @idx += 1 }
    end
  end

  def explode(subset, level = 0)
    if level.zero?
      @idx = 0
      @done = false
    end
    if subset.respond_to?(:each)
      if !@done && level == 4
        @done = true
        @numbers[@idx - 1] += subset.first unless @idx.zero?
        @numbers.delete_at(@idx)
        @numbers[@idx] = 0
        @idx += 1
        @numbers[@idx] += subset.last if @numbers[@idx]
        0
      else
        subset.map do |d|
          explode(d, level + 1)
        end
      end
    else
      @numbers[@idx].tap { @idx += 1 }
    end
  end

  def split(data)
    if data.respond_to?(:each)
      data.map { |d| split(d) }
    elsif !@done && data >= 10
      @done = true
      [
        data / 2,
        (data.to_f / 2).ceil
      ]
    else
      data
    end
  end
end
