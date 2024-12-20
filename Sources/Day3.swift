class Day3 : Day {
    private let MUL_REGEX = /mul\(([1-9][0-9]*),([1-9][0-9]*)\)/
    private let BLOCK_REGEX = /[don't\(\)|do\(\)]/
    private func part2(inputFile: String) -> String {
        var splitted = inputFile.split(separator: "don't()")
        let firstLine = splitted.remove(at: 0)
        let accumulator = Int(part1(inputFile: String(firstLine)))!

        let total = splitted.reduce(accumulator, {total, currentExpression in
            var subSplit = currentExpression.split(separator: "do()", maxSplits: 1)
            if subSplit.count == 2 {
                let doBlock = subSplit.remove(at: 1)

                let blockCount = Int(part1(inputFile: String(doBlock)))!

                return total + blockCount
            } else {
                return total
            }
        })

        return String(total)
    }

    private func part1(inputFile: String) -> String {
        let result = inputFile.matches(of: MUL_REGEX).reduce(0, {total, currentExpression in 
            let left = Int(currentExpression.1)!
            let right = Int(currentExpression.2)!

            return total + (left * right)
        })
        return String(result)
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
