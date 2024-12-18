struct Day1 : Day {
    private let NUMBER_PAIR = /([0-9]+)\s+([0-9]+)/

    private func part1(inputFile: String) -> String {
        let content = inputFile.split { $0.isNewline }

        var leftNumbers: [Int] = []
        var rightNumbers: [Int] = []

        for pair in content {
            if let match = pair.firstMatch(of: NUMBER_PAIR) {
                let left = Int(match.1)!
                let right = Int(match.2)!
                leftNumbers.append(left)
                rightNumbers.append(right)
            }
        }
        leftNumbers.sort()
        rightNumbers.sort()
        var accumulator = 0
        for (index, leftNumber) in leftNumbers.enumerated() {
            let rightNumber = rightNumbers[index]
            accumulator = accumulator + abs(leftNumber - rightNumber)
        }
        return String(accumulator)
    }

    public func run(part: Int, inputFile: String) -> String {
        return switch part {
        case 1:
            part1(inputFile: inputFile)
        default:
            "Invalid part \(part)"
        }
    }
}
