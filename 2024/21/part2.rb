class Node
  def initialize(key, px, py)
    @key = key
    @px = px
    @py = py
    @@all ||= {}
    @@all[[px, py]] = self
  end

  attr_reader :key, :px, :py
  attr_accessor :visited

  def self.all = @@all
  def self.reset = @@all = {}

  def up = @@all[[px, py - 1]]
  def down = @@all[[px, py + 1]]
  def left = @@all[[px - 1, py]]
  def right = @@all[[px + 1, py]]
  def adjacent = [up, down, left, right].compact

  def paths_to(dest, path = '', visited = [])
    return nil if visited.include?(self)

    if self == dest
      return [path] if path.chars.each_cons(2).count { _1 != _2 } <= 1

      return nil
    end

    visited += [self]

    [
      up&.paths_to(dest, "#{path}^", visited),
      down&.paths_to(dest, "#{path}v", visited),
      left&.paths_to(dest, "#{path}<", visited),
      right&.paths_to(dest, "#{path}>", visited)
    ].flatten.compact
  end
end

class NumericKeypad
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
end

Node.new('7', 0, 0)
Node.new('8', 1, 0)
Node.new('9', 2, 0)
Node.new('4', 0, 1)
Node.new('5', 1, 1)
Node.new('6', 2, 1)
Node.new('1', 0, 2)
Node.new('2', 1, 2)
Node.new('3', 2, 2)
Node.new('0', 1, 3)
Node.new('A', 2, 3)

nk_paths = {}
Node.all.values.permutation(2).each do |from, to|
  nk_paths[from.key] ||= {}
  nk_paths[from.key][to.key] = from.paths_to(to)
end

Node.reset

Node.new('^', 1, 0)
Node.new('A', 2, 0)
Node.new('<', 0, 1)
Node.new('v', 1, 1)
Node.new('>', 2, 1)

rk_paths = {}
Node.all.each_value do |node|
  rk_paths[node.key] = {}
  rk_paths[node.key][node.key] = node.paths_to(node)
end
Node.all.values.permutation(2).each do |from, to|
  rk_paths[from.key][to.key] = from.paths_to(to)
end

NK_PATHS = nk_paths.freeze
RK_PATHS = rk_paths.freeze

def build_seq(keys, result, paths = RK_PATHS, index = 0, prev_key = 'A', curr_path = '')
  if index == keys.length
    result << curr_path
    return
  end

  curr_key = keys[index]

  paths[prev_key][curr_key].each do |path|
    build_seq(keys, result, paths, index + 1, curr_key, "#{curr_path}#{path}A")
  end
end

$cache = {}
def shortest_seq(keys, depth)
  return keys.length if depth.zero?

  cache_key = [keys, depth]
  return $cache[cache_key] if $cache.key?(cache_key)

  sub_keys = keys.split('A')
  $cache[cache_key] = sub_keys.map do |sub_key|
    result = []
    build_seq("#{sub_key}A", result)
    min = result.map { shortest_seq(_1, depth - 1) }.min
    min.zero? ? 1 : min
  end.sum
end

def solve(input_list, max_depth)
  input_list.sum do |input|
    numpad_seq = []
    build_seq(input, numpad_seq, NK_PATHS)

    min = numpad_seq.map { |seq| shortest_seq(seq, max_depth) }.min
    min * input.to_i
  end
end

puts "Part 1: #{solve(File.read('input').lines.map(&:strip), 2)}"
puts "Part 2: #{solve(File.read('input').lines.map(&:strip), 25)}"
