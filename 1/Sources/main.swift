import Foundation

let input = "input.txt"
let numberPair = /([0-9]+)\s+([0-9]+)/

var leftNumbers: [Int] = []
var rightNumbers: [Int] = []

do {
    let content = try String(contentsOfFile: input).split { $0.isNewline }
    for pair in content {
        if let match = pair.firstMatch(of: numberPair) {
            let left = Int(match.1)!
            let right = Int(match.2)!
            leftNumbers.append(left)
            rightNumbers.append(right)
        }
    }
    leftNumbers.sort()
    rightNumbers.sort()
    var accumulator = 0
    for (index, leftNumber) in leftNumbers.enumerated() {
        let rightNumber = rightNumbers[index]
        accumulator = accumulator + abs(leftNumber - rightNumber)
    }
    print(accumulator)
} catch {
    print(error)
}
