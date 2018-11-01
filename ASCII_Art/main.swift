import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

extension String {
    func split(withInterval interval: Int) -> [String] {
        var result: [String] = []
        let chars = Array(characters)
        for index in stride(from: 0, to: chars.count, by: interval) {
            result.append(String(chars[index..<min(index+interval, chars.count)]))
        }
        return result
    }
}

let width = Int(readLine()!)!
let height = Int(readLine()!)!

var ASCIIHASH = [Character: [String]]()
let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ?"

for letter in alphabet.characters {
    ASCIIHASH[letter] = [String](repeating: "", count: height)
}

let tempText = readLine()!

let text = tempText.uppercased()

print("Text: \(text), Width: \(width), Height: \(height)", to: &errStream)

if height > 0 {
    for i in 0...(height-1) {

        let ROW = readLine()!
        let splitRow = ROW.split(withInterval: width)

        var offset = 0
        for partOfThatLetter in splitRow {
            let index = alphabet.index(alphabet.startIndex, offsetBy: offset)
            var currentChar = alphabet[index]
            ASCIIHASH[currentChar]![i] = partOfThatLetter
            offset+=1
        }

    }
}

if height > 0 {
    for i in 0...(height-1) {

        for letter in text.characters {
            let printThis = ASCIIHASH[letter]?[i] ?? ASCIIHASH["?"]![i]
            print(printThis, terminator:"")
        }
        print("")
    }
}
