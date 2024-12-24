struct Day4Coordinate : Hashable {
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

    public func up(increment: Int) -> Day4Coordinate {
        return down(increment: -increment)
    }

    public func down(increment: Int) -> Day4Coordinate {
        return Day4Coordinate(row: row, column: column + increment)
    }

    public func right(increment: Int) -> Day4Coordinate {
        return left(increment: -increment)
    }

    public func left(increment: Int) -> Day4Coordinate {
        return Day4Coordinate(row: row + increment, column: column)
    }

    public func diagonalDownLeft(increment: Int) -> Day4Coordinate {
        return down(increment: increment).left(increment: increment)
    }

    public func diagonalDownRight(increment: Int) -> Day4Coordinate {
        return right(increment: increment).down(increment: increment)
    }

    public func diagonalUpLeft(increment: Int) -> Day4Coordinate {
        return up(increment: increment).left(increment: increment)
    }

    public func diagonalUpRight(increment: Int) -> Day4Coordinate {
        return right(increment: increment).up(increment: increment)
    }

    private func stepped(length: Int, function: (Day4Coordinate, Int) -> Day4Coordinate) -> [Day4Coordinate] {
        var stepped: [Day4Coordinate] = []

        for index in stride(from: 1, to: (length + 1), by: 1) {
            stepped.append(function(self, index))
        }
        return stepped
    }

    public func surroundingPatterns(count: Int) -> [[Day4Coordinate]] {
        return [
            stepped(length: count, function: { $0.left(increment: $1) }),
            stepped(length: count, function: { $0.diagonalUpLeft(increment: $1) }),
            stepped(length: count, function: { $0.up(increment: $1) }),
            stepped(length: count, function: { $0.diagonalUpRight(increment: $1) }),
            stepped(length: count, function: { $0.right(increment: $1) }),
            stepped(length: count, function: { $0.diagonalDownRight(increment: $1) }),
            stepped(length: count, function: { $0.down(increment: $1) }),
            stepped(length: count, function: { $0.diagonalDownLeft(increment: $1) })
        ]
    }

    public func diagonals(count: Int) -> [[Day4Coordinate]] {
        return [
            [diagonalUpLeft(increment: count), diagonalDownRight(increment: count)],
            [diagonalUpRight(increment: count), diagonalDownLeft(increment: count)],
            [diagonalDownRight(increment: count), diagonalUpLeft(increment: count)],
            [diagonalDownLeft(increment: count), diagonalUpRight(increment: count)],
        ]
    }
}

enum Day4Letter {
    case x
    case m
    case a
    case s
    case invalid

    static func fromChar(char: String) -> Day4Letter {
        return switch char {
        case "X": self.x
        case "M": self.m
        case "A": self.a
        case "S": self.s
        default: self.invalid
        }
    }
}

class Day4Grid {
    private var grid : Dictionary<Day4Coordinate, Day4Letter> = Dictionary()
    private var width : Int = -1
    private var height : Int = -1

    init(input: String) {
        let splitted = input.split { $0.isNewline }

        for (rowIndex, fullRow) in splitted.enumerated() {
            for (columnIndex, cell) in fullRow.enumerated() {
                let coordinate = Day4Coordinate(row: rowIndex, column: columnIndex)
                let letter: Day4Letter = Day4Letter.fromChar(char: String(cell))
                grid.updateValue(letter, forKey: coordinate)
                width = columnIndex + 1
            }
            height = rowIndex + 1
        }
    }

    public func inBounds(coordinate: Day4Coordinate) -> Bool {
        return (coordinate.row >= 0 && coordinate.row < height) && (coordinate.column >= 0 && coordinate.column < width)
    }

    public func reduce<T>(initialAccumulator: T, function: (T, Day4Coordinate, Day4Letter) -> T) -> T {
        var accumulator = initialAccumulator
        
        for rowIndex in stride(from: 0, to: height, by: 1) {
            for columnIndex in stride(from: 0, to: width, by: 1) {
                let coordinate = Day4Coordinate(row: rowIndex, column: columnIndex)

                accumulator = function(accumulator, coordinate, grid[coordinate]!)
            }
        }

        return accumulator
    }

    public func size() -> (Int, Int) {
        return (width, height)
    }

    public func lookAround(coord: Day4Coordinate) -> Int {
        return coord.surroundingPatterns(count: 3).reduce(0, {total, coords in 
            if coords.allSatisfy({coord in inBounds(coordinate: coord)}) {
                let surrounding = coords.map({coord in 
                    return grid[coord]
                })

                return switch surrounding {
                case [Day4Letter.m, Day4Letter.a, Day4Letter.s]: total + 1
                default: total
                }
            } else {
                return total
            }
        })
    }

    public func lookDiagonal(coord: Day4Coordinate) -> Int {
        let diagonals = coord.diagonals(count: 1).reduce(0, {total, coords in 
            if coords.allSatisfy({coord in inBounds(coordinate: coord)}) {
                let surrounding = coords.map({coord in 
                    return grid[coord]
                })

                return switch surrounding {
                case [Day4Letter.m, Day4Letter.s]: total + 1
                default: total
                }
            } else {
                return total
            }
        })

        if diagonals == 2 {
            return 1
        }
        return 0
    }
}

class Day4 : Day {
    private func part2(inputFile: String) -> String {
        let grid = Day4Grid(input: inputFile)
        let result = grid.reduce(initialAccumulator: 0, function: {acc, coord, letter in
            let count = switch letter {
            case .a: grid.lookDiagonal(coord: coord)
            default: 0
            }

            return acc + count
        })
        return String(result)
    }

    private func part1(inputFile: String) -> String {
        let grid = Day4Grid(input: inputFile)
        let result = grid.reduce(initialAccumulator: 0, function: {acc, coord, letter in
            let count = switch letter {
            case .x: grid.lookAround(coord: coord)
            default: 0
            }

            return acc + count
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
