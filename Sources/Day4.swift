struct Coordinate : Hashable {
    public var row: Int
    public var column: Int

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    public func hash(into hasher: inout Hasher) {
        let identifier = "\(row);\(column)"
        return hasher.combine(identifier)
    }

    public func up(increment: Int) -> Coordinate {
        down(increment: -increment)
    }

    public func down(increment: Int) -> Coordinate {
        Coordinate(row: row, column: column + 1)
    }

    public func right(increment: Int) -> Coordinate {
        left(increment: -increment)
    }

    public func left(increment: Int) -> Coordinate {
        Coordinate(row: row + 1, column: column)
    }
}

enum Letter {
    case x
    case m
    case a
    case s
    case invalid

    static func fromChar(char: String) -> Letter {
        return switch char {
        case "X": self.x
        case "M": self.m
        case "A": self.a
        case "S": self.s
        default: self.invalid
        }
    }
}

class Grid {
    private var grid : Dictionary<Coordinate, Letter> = Dictionary()
    private var width : Int = -1
    private var height : Int = -1

    init(input: String) {
        let splitted = input.split { $0.isNewline }

        for (rowIndex, fullRow) in splitted.enumerated() {
            for (columnIndex, cell) in fullRow.enumerated() {
                let coordinate = Coordinate(row: rowIndex, column: columnIndex)
                let letter: Letter = Letter.fromChar(char: String(cell))
                grid.updateValue(letter, forKey: coordinate)
                width = columnIndex + 1
            }
            height = rowIndex + 1
        }
    }

    public func inBounds(coordinate: Coordinate) -> Bool {
        return (coordinate.row >= 0 && coordinate.row < height) && (coordinate.column >= 0 && coordinate.column < width)
    }

    public func reduce<T>(initialAccumulator: T, function: (T, Coordinate, Letter) -> T) -> T {
        var accumulator = initialAccumulator
        
        for rowIndex in stride(from: 0, to: height, by: 1) {
            for columnIndex in stride(from: 0, to: width, by: 1) {
                let coordinate = Coordinate(row: rowIndex, column: columnIndex)

                accumulator = function(accumulator, coordinate, grid[coordinate]!)
            }
        }

        return accumulator
    }

    public func size() -> (Int, Int) {
        return (width, height)
    }
}

class Day4 : Day {
    private func part2(inputFile: String) -> String {
        return String("Failed part 2")
    }

    private func part1(inputFile: String) -> String {
        let grid = Grid(input: inputFile)
        grid.reduce(initialAccumulator: 0, function: {acc, coord, letter in
            print("\(coord) -> \(letter)")
            return acc
        })
        return String("Failed part 1")
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
