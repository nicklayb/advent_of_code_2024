import Foundation
import ArgumentParser

@main
struct Advent2024: ParsableCommand {
    @Option(help: "Day execute")
    public var day: Int

    @Option(help: "Part to execute")
    public var part: Int = 1

    @Argument(help: "Input file to read")
    public var inputFile: String

    private func getDayClass() -> Optional<Day> {
        switch day {
        case 1:
            Optional.some(Day1())
        default:
            Optional.none
        }
    }

    private func readInput() throws -> String {
        return try String(contentsOfFile: "./inputs/\(inputFile)")
    }

    public func run() throws {
        print("Running part \(day)-\(part) using \(inputFile)")
        let dayClass = getDayClass()!

        let inputContent = try readInput()

        let result = dayClass.run(part: part, inputFile: inputContent)
        print("Result \(result)")
    }
}
//
// let input = "input.txt"
// let numberPair = /([0-9]+)\s+([0-9]+)/
//
// var leftNumbers: [Int] = []
// var rightNumbers: [Int] = []
//
// do {
//     let content = try String(contentsOfFile: input).split { $0.isNewline }
//     for pair in content {
//         if let match = pair.firstMatch(of: numberPair) {
//             let left = Int(match.1)!
//             let right = Int(match.2)!
//             leftNumbers.append(left)
//             rightNumbers.append(right)
//         }
//     }
//     leftNumbers.sort()
//     rightNumbers.sort()
//     var accumulator = 0
//     for (index, leftNumber) in leftNumbers.enumerated() {
//         let rightNumber = rightNumbers[index]
//         accumulator = accumulator + abs(leftNumber - rightNumber)
//     }
//     print(accumulator)
// } catch {
//     print(error)
// }
