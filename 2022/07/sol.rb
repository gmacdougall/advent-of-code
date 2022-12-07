#! /usr/bin/env ruby

FILESYSTEM = {}
current_dir = []

ARGF.each do |line|
  if line.start_with?('$')
    _, cmd, op = line.split(' ')
    case cmd
    when 'cd'
      case op
      when '/'
        current_dir = []
      when '..'
        current_dir.pop
      else
        current_dir.push op
      end
    end
  else
    a, b = line.split(' ')

    path = current_dir.join('/')
    FILESYSTEM[path] ||= {}
    if (a == 'dir')
      FILESYSTEM[path][b] = a
    else
      FILESYSTEM[path][b] = a.to_i
    end
  end
end

def calc(path)
  FILESYSTEM[path].sum do |name, size|
    if (size == 'dir')
      if path.nil? || path.empty?
        calc(name)
      else
        calc("#{path}/#{name}")
      end
    else
      size
    end
  end
end

puts(
  FILESYSTEM.keys.select do |key|
    calc(key) < 100_000
  end.sum { calc(_1) }
)

TOTAL_SPACE = 70_000_000
REQUIRED = 30_000_000

allocated = calc('')
unused = TOTAL_SPACE - allocated
needed = REQUIRED - unused

p(
  FILESYSTEM.keys.filter_map do |key|
    size = calc(key)
    size if size > needed
  end.min
)
