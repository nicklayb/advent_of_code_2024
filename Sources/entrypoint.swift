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
