struct Day6Coordinate : Hashable, Equatable, CustomStringConvertible {
    public var row: Int
    public var column: Int

    public var description: String { 
        return "{\(row), \(column)}"
    }

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    static func ==(left: Day6Coordinate, right: Day6Coordinate) -> Bool {
        return left.row == right.row && left.column == right.column
    }

    public func hash(into hasher: inout Hasher) {
        let identifier = "\(row);\(column)"
        return hasher.combine(identifier)
    }

    public func up(increment: Int) -> Day6Coordinate {
        return down(increment: -increment)
    }

    public func down(increment: Int) -> Day6Coordinate {
        return Day6Coordinate(row: row + increment, column: column)
    }

    public func right(increment: Int) -> Day6Coordinate {
        return Day6Coordinate(row: row, column: column + increment)
    }

    public func left(increment: Int) -> Day6Coordinate {
        return right(increment: -increment)
    }

    public func next(increment: Int = 1, direction: Day6Direction) -> Day6Coordinate {
        return switch direction {
        case .left: left(increment: increment)
        case .up: up(increment: increment)
        case .down: down(increment: increment)
        case .right: right(increment: increment)
        }
    }
}
enum Day6Direction {
    case up
    case down
    case left
    case right

    public func next() -> Day6Direction {
        return switch self {
        case .up: Day6Direction.right
        case .right: Day6Direction.down
        case .down: Day6Direction.left
        case .left: Day6Direction.up
        }
    }
}

class Day6Character : CustomStringConvertible {
    public var position: Day6Coordinate
    public var direction: Day6Direction = Day6Direction.up

    public var description: String { 
        return "\(direction) \(position)"
    }

    init(position: Day6Coordinate) {
        self.position = position
    }

    public func forward() -> Day6Coordinate {
        return position.next(direction: direction)
    }

    public func move(to: Day6Coordinate) {
        self.position = to
    }

    public func turn() {
        self.direction = self.direction.next()
    }
}

enum Day6Cell {
    case obstacle
    case empty
    case start

    static func fromChar(char: String) -> Day6Cell {
        return switch char {
        case "#": self.obstacle
        case ".": self.empty
        default: self.start
        }
    }
}

class Day6Grid {
    private var grid : Dictionary<Day6Coordinate, Day6Cell> = Dictionary()
    private var width : Int = -1
    private var height : Int = -1
    public var startingPosition : Optional<Day6Coordinate> = Optional.none

    init(input: String) {
        let splitted = input.split { $0.isNewline }

        for (rowIndex, fullRow) in splitted.enumerated() {
            for (columnIndex, cell) in fullRow.enumerated() {
                let coordinate = Day6Coordinate(row: rowIndex, column: columnIndex)
                let parsedCell = Day6Cell.fromChar(char: String(cell))
                var cell = Day6Cell.empty

                switch parsedCell {
                case Day6Cell.start:
                    startingPosition = Optional.some(coordinate)
                    cell = Day6Cell.empty
                default:
                    cell = parsedCell
                }

                grid.updateValue(cell, forKey: coordinate)
                width = columnIndex + 1
            }
            height = rowIndex + 1
        }
    }

    public func reduce<T>(initialAccumulator: T, function: (T, Day6Coordinate, Day6Cell) -> T) -> T {
        var accumulator = initialAccumulator
        
        for rowIndex in stride(from: 0, to: height, by: 1) {
            for columnIndex in stride(from: 0, to: width, by: 1) {
                let coordinate = Day6Coordinate(row: rowIndex, column: columnIndex)

                accumulator = function(accumulator, coordinate, grid[coordinate]!)
            }
        }

        return accumulator
    }

    public func hasObstacle(at: Day6Coordinate) -> Bool {
        if let cell = grid[at] {
            return cell == Day6Cell.obstacle
        }
        return false
    }

    public func inBounds(coordinate: Day6Coordinate) -> Bool {
        return (coordinate.row >= 0 && coordinate.row < height) && (coordinate.column >= 0 && coordinate.column < width)
    }

    public func size() -> (Int, Int) {
        return (width, height)
    }
}

class Map : CustomStringConvertible {
    private var grid: Day6Grid
    public var character: Day6Character
    public var steps: Set<Day6Coordinate> = Set()

    public var description : String {
        var previousRow = 0
        return grid.reduce(initialAccumulator: "", function: {acc, coord, cell in 
            var newLine = false
            if coord.row != previousRow {
                newLine = true
                previousRow = coord.row
            }
            var cellChar = switch cell {
            case .obstacle: "#"
            default: "_"
            }
            if coord == character.position {
                cellChar = "!"
            }
            if steps.contains(coord) {
                cellChar = "░"
            }
            if newLine {
                cellChar = "\n\(cellChar)"
            }
            return acc + cellChar
        })
    }

    init(input: String) {
        self.grid = Day6Grid(input: input)
        let startingPosition = grid.startingPosition!
        self.character = Day6Character(position: startingPosition)
    }

    public func currentPosition() -> Day6Coordinate {
        return character.position
    }

    public func findExit() {
        steps.insert(character.position)

        while (grid.inBounds(coordinate: character.position)) {
            let newPosition = nextCell()
        }

        print("\(self)")
    }

    private func nextCell() {
        let nextPosition = character.forward()

        if grid.hasObstacle(at: nextPosition) {
            print("\(self)")
            character.turn()
            nextCell()
        } else {
            move(to: nextPosition)
        }
    }
    private func move(to: Day6Coordinate) {
        character.move(to: to)
        if grid.inBounds(coordinate: to) {
            steps.insert(to)
        }
    }
}

class Day6 : Day {
    private func part2(inputFile: String) -> String {
        return String("Fix me")
    }

    private func part1(inputFile: String) -> String {
        let map = Map(input: inputFile)
        map.findExit()
        return String(map.steps.count)
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
