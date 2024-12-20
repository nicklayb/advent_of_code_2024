enum Status {
    case valid
    case invalid
}

enum Direction {
    case ascending(Int)
    case descending(Int)
    case overflow
}

extension Direction: Equatable {
    static func ==(left: Direction, right: Direction) -> Bool {
        switch (left, right) {
        case (.overflow, .overflow): return true
        case (.ascending(_), .ascending(_)): return true
        case (.descending(_), .descending(_)): return true
        default: return false
        }
    }
}

class Day2 : Day {
    private var attemptCorrection = false
    private func part2(inputFile: String) -> String {
        attemptCorrection = true
        return part1(inputFile: inputFile)
    }

    private func part1(inputFile: String) -> String {
        let splitted = inputFile.split { $0.isNewline }
        let total = splitted.reduce(0, { (count: Int, currentLine: String.SubSequence) -> Int in
            let splitted = String(currentLine).split { $0 == " " }.map { Int($0)! }
            if safetyStatus(line: splitted) == Direction.overflow {
                if attemptCorrection {
                    for (index, _) in splitted.enumerated() {
                        var updatedLine = splitted
                        updatedLine.remove(at: index)
                        if safetyStatus(line: updatedLine) != Direction.overflow {
                            return count + 1
                        }
                    }
                    return count
                } else {
                    return count + 1
                }
            }
            return count + 1
        })

        return String(total)
    }

    private func safetyStatus(line: [Int]) -> Direction {
        var line = line
        let first = line.remove(at: 0)
        let second = line.remove(at: 0)

        let direction = getDirection(first: first, second: second)
        let newDirection = getDirection(currentDirection: direction, row: line)
        return newDirection
    }

    private func getDirection(currentDirection: Direction, row: [Int]) -> Direction {
        var direction = currentDirection
        var newDirection = currentDirection
        for number in row {
            newDirection = switch direction {
            case .ascending(let currentNumber): getDirection(first: currentNumber, second: number)
            case .descending(let currentNumber): getDirection(first: currentNumber, second: number)
            case .overflow: Direction.overflow
            }


            if newDirection != direction || newDirection == Direction.overflow {
                return Direction.overflow
            }
            direction = newDirection
        }
        return newDirection
    }

    private func getDirection(first: Int, second: Int) -> Direction {
        if abs(second - first) >= 4 {
            return Direction.overflow
        }
        if second > first {
            return Direction.ascending(second)
        }
        if first > second {
            return Direction.descending(second)
        }
        return Direction.overflow
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
