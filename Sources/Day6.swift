
class Day6 : Day {
    struct Coordinate : Hashable, Equatable, CustomStringConvertible {
        public var row: Int
        public var column: Int

        public var description: String { 
            return "{\(row), \(column)}"
        }

        init(row: Int, column: Int) {
            self.row = row
            self.column = column
        }

        static func ==(left: Coordinate, right: Coordinate) -> Bool {
            return left.row == right.row && left.column == right.column
        }

        public func hash(into hasher: inout Hasher) {
            let identifier = "\(row);\(column)"
            return hasher.combine(identifier)
        }

        public func up(increment: Int) -> Coordinate {
            return down(increment: -increment)
        }

        public func down(increment: Int) -> Coordinate {
            return Coordinate(row: row + increment, column: column)
        }

        public func right(increment: Int) -> Coordinate {
            return Coordinate(row: row, column: column + increment)
        }

        public func left(increment: Int) -> Coordinate {
            return right(increment: -increment)
        }

        public func next(increment: Int = 1, direction: Direction) -> Coordinate {
            return switch direction {
            case .left: left(increment: increment)
            case .up: up(increment: increment)
            case .down: down(increment: increment)
            case .right: right(increment: increment)
            }
        }
    }
    enum Direction {
        case up
        case down
        case left
        case right

        public func next() -> Direction {
            return switch self {
            case .up: Direction.right
            case .right: Direction.down
            case .down: Direction.left
            case .left: Direction.up
            }
        }
    }

    class Character : CustomStringConvertible {
        public var position: Coordinate
        public var direction: Direction = Direction.up

        public var description: String { 
            return "\(direction) \(position)"
        }

        init(position: Coordinate) {
            self.position = position
        }

        public func forward() -> Coordinate {
            return position.next(direction: direction)
        }

        public func move(to: Coordinate) {
            self.position = to
        }

        public func turn() {
            self.direction = self.direction.next()
        }
    }

    enum Cell {
        case obstacle
        case empty
        case start

        static func fromChar(char: String) -> Cell {
            return switch char {
            case "#": self.obstacle
            case ".": self.empty
            default: self.start
            }
        }
    }

    class Grid {
        private var grid : Dictionary<Coordinate, Cell> = Dictionary()
        private var width : Int = -1
        private var height : Int = -1
        public var startingPosition : Optional<Coordinate> = Optional.none

        init(input: String) {
            let splitted = input.split { $0.isNewline }

            for (rowIndex, fullRow) in splitted.enumerated() {
                for (columnIndex, cell) in fullRow.enumerated() {
                    let coordinate = Coordinate(row: rowIndex, column: columnIndex)
                    let parsedCell = Cell.fromChar(char: String(cell))
                    var cell = Cell.empty

                    switch parsedCell {
                    case Cell.start:
                        startingPosition = Optional.some(coordinate)
                        cell = Cell.empty
                    default:
                        cell = parsedCell
                    }

                    grid.updateValue(cell, forKey: coordinate)
                    width = columnIndex + 1
                }
                height = rowIndex + 1
            }
        }

        public func reduce<T>(initialAccumulator: T, function: (T, Coordinate, Cell) -> T) -> T {
            var accumulator = initialAccumulator
            
            for rowIndex in stride(from: 0, to: height, by: 1) {
                for columnIndex in stride(from: 0, to: width, by: 1) {
                    let coordinate = Coordinate(row: rowIndex, column: columnIndex)

                    accumulator = function(accumulator, coordinate, grid[coordinate]!)
                }
            }

            return accumulator
        }

        public func hasObstacle(at: Coordinate) -> Bool {
            if let cell = grid[at] {
                return cell == Cell.obstacle
            }
            return false
        }

        public func inBounds(coordinate: Coordinate) -> Bool {
            return (coordinate.row >= 0 && coordinate.row < height) && (coordinate.column >= 0 && coordinate.column < width)
        }

        public func size() -> (Int, Int) {
            return (width, height)
        }
    }

    class Map : CustomStringConvertible {
        private var grid: Grid
        public var character: Character
        public var steps: Set<Coordinate> = Set()

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
            self.grid = Grid(input: input)
            let startingPosition = grid.startingPosition!
            self.character = Character(position: startingPosition)
        }

        public func currentPosition() -> Coordinate {
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
        private func move(to: Coordinate) {
            character.move(to: to)
            if grid.inBounds(coordinate: to) {
                steps.insert(to)
            }
        }
    }

    private func part2(inputFile: String) -> String {
        return String("Not interested")
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
