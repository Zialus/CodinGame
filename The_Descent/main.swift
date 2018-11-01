import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

// game loop
while true {
    var mountains = [Int]()
    for i in 0...7 {
        let mountainH = Int(readLine()!)! // represents the height of one mountain.
        mountains.append(mountainH)
    }

    var max = Int.min
    var chosenMountain = 0

    for i in 0...7 {
        if mountains[i] > max {
            max = mountains[i]
            chosenMountain = i
        }
    }

    print(chosenMountain) // The index of the mountain to fire on.
}
