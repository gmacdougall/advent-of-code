#!/usr/bin/env ruby

input = ARGF.read.split(' ').map(&:to_i)

commands = []
metadata_entries = []

def read_header(commands, number_of_child_nodes, number_of_metadata_entries)
  number_of_metadata_entries.times do
    commands.push(:metadata)
  end
  number_of_child_nodes.times do
    commands.push(:child)
  end
end

read_header(commands, input.shift, input.shift)
while !input.empty?
  if commands.pop == :child
    read_header(commands, input.shift, input.shift)
  else
    metadata_entries << input.shift
  end
end

puts metadata_entries.sum
