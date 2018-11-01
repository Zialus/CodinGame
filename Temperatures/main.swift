import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

let n = Int(readLine()!)! // the number of temperatures to analyse
let temps = readLine()! // the n temperatures expressed as integers ranging from -273 to 5526

let tempsList = temps.characters.split{$0 == " "}.map{Int(String($0)) ?? 0}

if tempsList.count == 0 {
    print(0)
    exit(0)
}

var closestToZero = Int.max

print("tempList = \(tempsList)", to: &errStream)

for temp in tempsList {
    if abs(temp - 0) < abs(closestToZero - 0) {
        closestToZero = temp
    } else if abs(temp - 0) == abs(closestToZero - 0) {
        closestToZero = max(temp, closestToZero)
    }
}

print("closestToZero = \(closestToZero)", to: &errStream)

print(closestToZero)
