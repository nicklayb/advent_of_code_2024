
class Day1 : Day {
    struct SideBySideLists {
        private let NUMBER_PAIR = /([0-9]+)\s+([0-9]+)/
        private var leftNumbers : [Int] = []
        private var rightNumbers : [Int] = []

        init(fileContent: String) {
            let content = fileContent.split { $0.isNewline }
            for pair in content {
                if let match = pair.firstMatch(of: NUMBER_PAIR) {
                    let left = Int(match.1)!
                    let right = Int(match.2)!
                    leftNumbers.append(left)
                    rightNumbers.append(right)
                }
            }
        }

        public mutating func sort() {
            leftNumbers.sort()
            rightNumbers.sort()
        }

        public func getLeft() -> [Int] {
            return leftNumbers
        }

        public func getRight() -> [Int] {
            return rightNumbers
        }
    }
    private func part2(inputFile: String) -> String {
        let lists = SideBySideLists(fileContent: inputFile)
        let result = lists.getLeft().reduce(0, {total, currentLeft in 
            let numberCount = lists.getRight().reduce(0, {countTotal, currentRight in 
                if currentLeft == currentRight {
                    return countTotal + 1
                }
                return countTotal
            })

            return total + (currentLeft * numberCount)
        })

        return String(result)
    }

    private func part1(inputFile: String) -> String {
        var lists = SideBySideLists(fileContent: inputFile)

        lists.sort()
        var accumulator = 0
        for (index, leftNumber) in lists.getLeft().enumerated() {
            let rightNumber = lists.getRight()[index]
            accumulator = accumulator + abs(leftNumber - rightNumber)
        }
        return String(accumulator)
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
