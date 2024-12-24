typealias Update = [Int]
typealias Rule = (Int, Int)

class UpdateSet {
    public var orderingRules: [Rule] = []
    public var updates: [Update] = []

    init(inputFile: String) {
        let splitted = inputFile.split(separator: "\n\n")

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

    public func validate(update: Update) -> Bool {
        return orderingRules.allSatisfy({ validate(update: update, with: $0) })
    }

    private func validate(update: Update, with: Rule) -> Bool {
        let (left, right) = with
        let found: [Int] = update.reduce([], {(foundAcc, item: Int) in
            if (item == left || item == right) {
                return foundAcc + [item]
            }
            return foundAcc
        })

        if found.count == 2 {
            let foundLeft: Int = found[0]
            let foundRight: Int = found[1]

            return (foundLeft == left && foundRight == right)
        }
        return true
    }

    public func correct(update: Update) -> Optional<Update> {
        switch fixRule(update: update) {
        case Optional.some(var updated):
            var finished = false

            while !finished {
                switch fixRule(update: updated) {
                case Optional.none: 
                    finished = true

                case Optional.some(let newUpdated):
                    updated = newUpdated
                }
            }

            return updated

        case Optional.none:
            return Optional.none
        }
    }

    private func fixRule(update: Update) -> Optional<Update> {
        let (corrected, updated) = orderingRules.reduce((false, update), {acc, rule in
            let (wasCorrected, updatedUpdate) = acc
            if !validate(update: updatedUpdate, with: rule) {
                let correctedUpdate = correct(update: updatedUpdate, with: rule)
                return (true, correctedUpdate)
            }
            return (wasCorrected, updatedUpdate)
        })
        if corrected {
            return Optional.some(updated)
        }
        return Optional.none
    }

    private func correct(update: Update, with: Rule) -> Update {
        let (left, right) = with
        var updatedUpdate = update
        let leftIndex = updatedUpdate.firstIndex(of: left)!
        let rightIndex = updatedUpdate.firstIndex(of: right)!
        updatedUpdate.swapAt(leftIndex, rightIndex)
        return updatedUpdate
    }
}

class Day5 : Day {
    private func part2(inputFile: String) -> String {
        let updateSet = UpdateSet(inputFile: inputFile)
        let middles: [Int] = updateSet.updates.reduce([], {acc, update in
            let updated = updateSet.correct(update: update)
            if let unwrappedUpdated = updated {
                let index = update.count / 2
                let middle = unwrappedUpdated[index]

                return acc + [middle]
            }
            return acc
        })
        let sum = middles.reduce(0, {$0 + $1})
        return String(sum)
    }

    private func part1(inputFile: String) -> String {
        let updateSet = UpdateSet(inputFile: inputFile)
        let middles: [Int] = updateSet.updates.reduce([], {acc, update in
            print("Checking: \(update)")
            if updateSet.validate(update: update) {
                print("Valid")
                let index = update.count / 2
                let middle = update[index]

                return acc + [middle]
            }
            print("Invalid")
            return acc
        })
        let sum = middles.reduce(0, {$0 + $1})
        return String(sum)
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
