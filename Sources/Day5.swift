class Day5 : Day {
    private func part2(inputFile: String) -> String {
        return String("Fix me")
    }

    private func part1(inputFile: String) -> String {
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
