import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

var MIMETABLE = [String: String]()

let N = Int(readLine()!)! // Number of elements which make up the association table.
let Q = Int(readLine()!)! // Number Q of file names to be analyzed.

for i in 0...(N-1) {
    let inputs = (readLine()!).characters.split{$0 == " "}.map(String.init)

    let EXT = inputs[0].lowercased() // file extension
    let MT = inputs[1] // MIME type.
    MIMETABLE[EXT] = MT
}

for i in 0...(Q-1) {
    let FNAME = readLine()! // One file name per line.
    var FCOMPONENTS = FNAME.characters.split(separator:".", omittingEmptySubsequences: false).map(String.init)

    if FCOMPONENTS.count == 1 {
        print("UNKNOWN")
    } else {
        let fileEXT = FCOMPONENTS.last!.lowercased()
        let printThis = MIMETABLE[fileEXT] ?? "UNKNOWN"
        print(printThis)
    }
}
