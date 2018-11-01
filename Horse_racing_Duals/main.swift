import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

var bestDiffSoFar = Int.max

var allHorsesStrenghTemp = [Int]()

let N = Int(readLine()!)!
print("N: \(N)", to: &errStream)

for i in 0...(N-1) {
    let pi = Int(readLine()!)!
    allHorsesStrenghTemp.append(pi)
}

let allHorsesStrengh = allHorsesStrenghTemp.sorted()

print(allHorsesStrengh, to: &errStream)

for i in 0...(N-2) {
    let pi = allHorsesStrengh[i]
    let npi = allHorsesStrengh[i+1]
    let diff = abs(pi-npi)
    if diff < bestDiffSoFar {
        print("New best: \(diff)", to: &errStream)
        bestDiffSoFar = diff
    }

}

print(bestDiffSoFar)
