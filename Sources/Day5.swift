class UpdateSet {
    private var orderingRules: [(Int, Int)] = []
    private var updates: [[Int]] = []

    init(inputFile: String) {
        let splitted = inputFile.split(separator: "\n\n")
        let length = splitted.count

        decodeOrderingRules(input: String(splitted[0]))
        decodeUpdates(input: String(splitted[1]))
    }

    private func decodeOrderingRules(input: String) {
        for row in input.split { $0.isNewline } {
            let splitted = row.split(separator: "|").map { Int($0) }
            let orderingRule = (splitted[0]!, splitted[1]!)
            orderingRules.append(orderingRule)
        }
    }

    private func decodeUpdates(input: String) {
        for line in input.split{ $0.isNewline } {
            let updateRow = line.split(separator: ",").map { Int($0)! }
            updates.append(updateRow)
        }
    }
}

class Day5 : Day {
    private func part2(inputFile: String) -> String {
        return String("Fix me")
    }

    private func part1(inputFile: String) -> String {
        UpdateSet(inputFile: inputFile)
        return String("Fix me")
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
