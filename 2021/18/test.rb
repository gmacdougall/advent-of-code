#! /usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'snailfish'

# Tests
class SnailfishTest < Minitest::Test
  def test_parse
    valid_numbers = %w[
      [1,2]
      [[1,2],3]
      [9,[8,7]]
      [[1,9],[8,5]]
      [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
      [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
      [[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]
    ]
    valid_numbers.each do |sn|
      assert_equal(
        sn,
        SnailfishNumber.parse(sn).to_s
      )
    end
  end

  def test_explode
    assert_equal(
      '[[[[0,9],2],3],4]',
      SnailfishNumber.parse('[[[[[9,8],1],2],3],4]').to_s
    )

    assert_equal(
      '[7,[6,[5,[7,0]]]]',
      SnailfishNumber.parse('[7,[6,[5,[4,[3,2]]]]]').to_s
    )

    assert_equal(
      '[[3,[2,[8,0]]],[9,[5,[7,0]]]]',
      SnailfishNumber.parse('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]').to_s
    )
  end

  def test_split
    assert_equal(
      '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]',
      SnailfishNumber.parse('[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]').to_s
    )
  end

  def test_add1
    sn = SnailfishNumber.parse('[1,1]')
    sn += SnailfishNumber.parse('[2,2]')
    sn += SnailfishNumber.parse('[3,3]')
    sn += SnailfishNumber.parse('[4,4]')
    assert_equal(
      '[[[[1,1],[2,2]],[3,3]],[4,4]]',
      sn.to_s
    )
  end

  def test_add2
    sn = SnailfishNumber.parse('[1,1]')
    sn += SnailfishNumber.parse('[2,2]')
    sn += SnailfishNumber.parse('[3,3]')
    sn += SnailfishNumber.parse('[4,4]')
    sn += SnailfishNumber.parse('[5,5]')
    assert_equal(
      '[[[[3,0],[5,3]],[4,4]],[5,5]]',
      sn.to_s
    )
  end

  def test_add3
    sn = SnailfishNumber.parse('[1,1]')
    sn += SnailfishNumber.parse('[2,2]')
    sn += SnailfishNumber.parse('[3,3]')
    sn += SnailfishNumber.parse('[4,4]')
    sn += SnailfishNumber.parse('[5,5]')
    sn += SnailfishNumber.parse('[6,6]')
    assert_equal(
      '[[[[5,0],[7,4]],[5,5]],[6,6]]',
      sn.to_s
    )
  end

  def test_add4
    sn = SnailfishNumber.parse('[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]')
    sn += SnailfishNumber.parse('[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]')
    assert_equal(
      '[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]',
      sn.to_s
    )
  end

  def test_add_complex
    sn = %w(
      [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
      [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
      [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
      [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
      [7,[5,[[3,8],[1,4]]]]
      [[2,[2,2]],[8,[8,1]]]
      [2,9]
      [1,[[[9,3],9],[[9,0],[0,7]]]]
      [[[5,[7,4]],7],1]
      [[[[4,2],2],6],[8,7]]
    ).map { SnailfishNumber.parse(_1) }.inject(:+)

    assert_equal(
      '[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]',
      sn.to_s
    )
  end

  def test_final_example
    sn = %w(
      [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
      [[[5,[2,8]],4],[5,[[9,9],0]]]
      [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
      [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
      [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
      [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
      [[[[5,4],[7,7]],8],[[8,3],8]]
      [[9,3],[[9,9],[6,[4,9]]]]
      [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
      [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    ).map { SnailfishNumber.parse(_1) }.inject(:+)

    assert_equal(
      '[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]',
      sn.to_s
    )
  end

  def test_magnitude1
    sn = SnailfishNumber.parse('[[9,1],[1,9]]')
    assert_equal(129, sn.magnitude)
  end

  def test_magnitude2
    sn = SnailfishNumber.parse('[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]')
    assert_equal(4140, sn.magnitude)
  end
end
