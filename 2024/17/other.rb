example = <<~TXT
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
TXT

def parse(input)
  initial_values, program = input.split("\n\n")
  strA, strB, strC = initial_values.split("\n")
  regA = strA[/\d+/].to_i
  regB = strB[/\d+/].to_i
  regC = strC[/\d+/].to_i
  instructions = program[/[\d,]+/]
  ThreeBitComputer.new(regA, regB, regC, instructions.split(',').map(&:to_i))
end

class ThreeBitComputer
  attr_reader :regA, :regB, :regC, :instructions, :output

  def initialize(regA, regB, regC, instructions)
    @regA = regA
    @regB = regB
    @regC = regC
    @instructions = instructions
    @output = []
  end

  def setRegA(newA)
    @regA = newA
  end

  def clearOutput
    @output = []
  end

  def instruction(i)
    case i
    when 0
      :adv
    when 1
      :bxl
    when 2
      :bst
    when 3
      :jnz
    when 4
      :bxc
    when 5
      :out
    when 6
      :bdv
    when 7
      :cdv
    else
      raise "invalid instruction #{i}"
    end
  end

  def operand(o)
    case o
    when (0..3)
      o
    when 4
      regA
    when 5
      regB
    when 6
      regC
    else
      raise "invalid operand #{o}"
    end
  end

  def adv(arg)
    @regA = regA / (2**operand(arg))
  end

  def bdv(arg)
    @regB = regA / (2**operand(arg))
  end

  def cdv(arg)
    @regC = regA / (2**operand(arg))
  end

  def bxl(arg)
    @regB = regB ^ arg
  end

  def bxc(_arg)
    @regB = regB ^ regC
  end

  def bst(arg)
    @regB = operand(arg) % 8
  end

  def out(arg)
    @output << operand(arg) % 8
    # p @output
  end

  # this one is weird, it returns an instruction pointer
  def jnz(arg)
    arg
  end
end

def runInstructions(computer, instructions)
  i = 0
  max_i = instructions.length
  while !i.nil? && i < max_i
    instr = computer.instruction(instructions[i])
    # puts "#{instr}(#{instructions[i+1]})"
    if instr == :jnz
      break if computer.regA.nil? || computer.regA == 0

      i = computer.jnz(instructions[i + 1])
    else
      computer.send(instr, instructions[i + 1])
      i += 2
    end
  end

  computer.output
end

def part1(input)
  computer = parse(input)
  runInstructions(computer, computer.instructions).join(',')
end

def part2(input)
  computer = parse(input)
  instructions = computer.instructions

  i = instructions.length - 1
  prefixes = ['']
  while i >= 0
    valid_inputs = []
    (0...8).each do |digit|
      prefixes.each do |prefix|
        str_a = "#{prefix}#{digit}"
        int_a = str_a.to_i(8)
        computer.setRegA(int_a)
        computer.clearOutput

        result = runInstructions(computer, instructions)
        # puts "#{str_a}(#{int_a}) -> #{result.inspect} ==? #{instructions[i..]}"
        valid_inputs << str_a if result == instructions[i..]
      end
    end
    i -= 1
    prefixes = valid_inputs
  end

  prefixes.map { |p| p.to_i(8) }.min
end

def testA(input, regA)
  computer = parse(input)
  computer.setRegA(regA)
  runInstructions(computer, computer.instructions)
end

puts 'Part 1'
p part1(example)

challenge = File.read('input')
p part1(challenge)

example2 = <<~TXT
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,3,5,4,3,0
TXT

puts 'Part 2'
p part2(example2)
p part2(challenge)
