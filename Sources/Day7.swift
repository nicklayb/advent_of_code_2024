class Day7 : Day {
    enum Operator {
        case multiply
        case add

        public static func toString(operand: Operator) -> String {
            return switch operand {
            case .multiply: "x"
            case .add: "+"
            }
        }

        public func apply(left: Int, right: Int) -> Int {
            return switch self {
            case .multiply: left * right
            case .add: left + right
            }
        }
    }

    enum InstructionPart {
        case operand(Operator)
        case number(Int)

        public static func new(number: Int) -> InstructionPart{
            return .number(number)
        }

        public static func new(operand: Operator) -> InstructionPart{
            return .operand(operand)
        }

        public func toString() -> String {
            return switch self {
            case InstructionPart.operand(let operand): Operator.toString(operand: operand)
            case InstructionPart.number(let number): String(number)
            }
        }
    }

    class Instruction {
        private var constants : [Int] = []
        private var operators : [Operator] = []
        private var sum : Int

        init(input: String) {
            let splitted = input.split(separator: ": ", maxSplits: 2)
            sum = Int(splitted[0])!
            constants = splitted[1].split(separator: " ").map { Int($0)! }
        }

        public func setOperators(operators: [Operator]) {
            self.operators = operators
        }

        public func toSequence() -> [InstructionPart] {
            var parts: [InstructionPart] = []

            for (index, number) in constants.enumerated() {
                if index > 0 {
                    parts += [InstructionPart.new(operand: operators[index - 1])]
                }
                parts += [InstructionPart.new(number: number)]
            }

            return parts
        }

        public func evaluate() -> Optional<Int> {
            if !isValid() {
                return Optional.none
            }
            var mutatingConstants = constants
            var sum = mutatingConstants.removeFirst()

            for (index, constant) in mutatingConstants.enumerated() {
                let operand = operators[index]
                sum = operand.apply(left: sum, right: constant)
            }
            
            return Optional.some(sum)
        }

        public func isTrue() -> Bool {
            return switch evaluate() {
            case .none: false
            case .some(let sum): self.sum == sum
            }
        }

        public func toString() -> String {
            print("Constants: \(constants)")
            print("Operators: \(operators)")
            print("Sum: \(sum)")
            if !isValid() {
                return "Invalid operators"
            }

            var output = toSequence().reduce("", {acc, part in
                return acc + part.toString()
            })

            return output + "=\(sum)"
        }

        private func isValid() -> Bool {
            return constants.count - 1 == operators.count
        }
    }

    private func part2(inputFile: String) -> String {
        return String("Fix me")
    }

    private func part1(inputFile: String) -> String {
        let instruction = Instruction(input: "12: 6 6")
        instruction.setOperators(operators: [Operator.add])

        print("\(instruction.isTrue())")

        return String(instruction.toString())
    }

    public func run(part: Int, inputFile: String) -> String {
        return switch part {
        case 1:
            part1(inputFile: inputFile)
        case 2: 
            part2(inputFile: inputFile)
        default:
            "Invalid part \(part)"
        }
    }
}
