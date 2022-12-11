#! /usr/bin/env ruby

sample =  [
{
  items: [79, 98],
  op: -> old { old * 19 },
  test_mod: 23,
  if_true: 2,
  if_false: 3
},
{
  items: [54, 65, 75, 74],
  op: -> old { old + 6 },
  test_mod: 19,
  if_true: 2,
  if_false: 0
},
{
  items: [79, 60, 97],
  op: -> old { old * old },
  test_mod: 13,
  if_true: 1,
  if_false: 3
},
{
  items: [74],
  op: -> old { old + 3 },
  test_mod: 17,
  if_true: 0,
  if_false: 1
}
]

input = [
{
  items: [59, 74, 65, 86],
  op: -> old { old * 19 },
  test_mod: 7,
  if_true: 6,
  if_false: 2,
},
{
  items: [62, 84, 72, 91, 68, 78, 51],
  op: -> old { old + 1 },
  test_mod: 2,
  if_true: 2,
  if_false: 0,
},
{
  items: [78, 84, 96],
  op: -> old { old + 8 },
  test_mod: 19,
  if_true: 6,
  if_false: 5,
},
{
  items: [97, 86],
  op: -> old { old * old },
  test_mod: 3,
  if_true: 1,
  if_false: 0,
},
{
  items: [50],
  op: -> old { old + 6 },
  test_mod: 13,
  if_true: 3,
  if_false: 1,
},
{
  items: [73, 65, 69, 65, 51],
  op: -> old { old * 17 },
  test_mod: 11,
  if_true: 4,
  if_false: 7,
},
{
  items: [69, 82, 97, 93, 82, 84, 58, 63],
  op: -> old { old + 5 },
  test_mod: 5,
  if_true: 5,
  if_false: 7,
},
{
  items: [81, 78, 82, 76, 79, 80],
  op: -> old { old + 3 },
  test_mod: 17,
  if_true: 3,
  if_false: 4,
},
]

todo = input

inspection_count = Hash.new(0)

20.times do
  todo.each_with_index do |monkey, idx|
    while monkey[:items].any?
      inspection_count[idx] += 1
      item = monkey[:items].shift
      item = monkey[:op].call(item)
      item /= 3

      throw_to = item % monkey[:test_mod] == 0 ? monkey[:if_true] : monkey[:if_false]
      todo[throw_to][:items].push item
    end
  end
end

p inspection_count.values.max(2).inject(:*)
