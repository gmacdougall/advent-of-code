#!/usr/bin/env ruby

input = ARGF.read.split(' ').map(&:to_i)

commands = []
metadata_entries = []

def read_header(commands, number_of_child_nodes, number_of_metadata_entries)
  commands.push([number_of_child_nodes, number_of_metadata_entries])
  number_of_child_nodes.times do
    commands.push(:child)
  end
end

read_header(commands, input.shift, input.shift)
while !input.empty?
  command = commands.pop
  if command == :child
    read_header(commands, input.shift, input.shift)
  else
    number_of_child_nodes, number_of_metadata_entries = command

    if number_of_child_nodes.zero?
      metadata_entries << input.shift(number_of_metadata_entries).sum
    else
      values = metadata_entries.pop(number_of_child_nodes)

      new_values = []
      number_of_metadata_entries.times do
        new_values.push(values[input.shift - 1] || 0)
      end

      metadata_entries.push(new_values.sum)
    end
  end
end

puts metadata_entries.inspect
