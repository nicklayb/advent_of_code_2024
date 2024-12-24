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
        return switch day {
        case 1:
            Optional.some(Day1())
        case 2:
            Optional.some(Day2())
        case 3:
            Optional.some(Day3())
        case 4:
            Optional.some(Day4())
        case 5:
            Optional.some(Day5())
        case 6:
            Optional.some(Day6())
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
