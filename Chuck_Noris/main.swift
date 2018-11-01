import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

let MESSAGE = readLine()!

func pad(string : String, toSize: Int) -> String {
    var padded = string

    guard (toSize - string.characters.count >= 0) else {
        // If strings to be padded are longer than 7 bits something went wrong
        exit(1)
    }
    for _ in 0..<toSize - string.characters.count {
        padded = "0" + padded
    }
    return padded
}

func stringToBinaryString (myString: String) -> String {
    // Array of characters
    let characterArray = [Character](myString.characters)

    // Array of asccii values
    let asciiArray = characterArray.map({String($0).unicodeScalars.first!.value})

    // Array of binary values
    let binaryArrayNotPadded = asciiArray.map({String($0, radix: 2)})

    // Pad all binary values to 7bits
    var binaryArrayPadded = [String]()
    for binaryNotPadded in binaryArrayNotPadded{
        binaryArrayPadded.append( pad(string: binaryNotPadded, toSize: 7) )
    }

    // Reduce the array into a String
    let result = binaryArrayPadded.joined(separator: "")

    return result
}

func binaryToUnary (myBinary: String) -> String {

    var result = ""

    var zerosCounter = 0
    var onesCounter = 0

    var firstChar = myBinary.characters.first
    for (index, char) in myBinary.characters.enumerated() {

        switch char {
        case "0":
            if onesCounter != 0 {
                let ones = String(repeating: ("0" as Character), count: onesCounter)
                result+=ones+" "
                onesCounter = 0
            }

            if zerosCounter == 0 {
                result+="00 "
            }
            zerosCounter+=1

        case "1":
            if zerosCounter != 0 {
                let zeros = String(repeating: ("0" as Character), count: zerosCounter)
                result+=zeros+" "
                zerosCounter = 0
            }

            if onesCounter == 0 {
                result+="0 "
            }
            onesCounter+=1

        default:
            // If strings don't have only 0s or 1s something went wrong
            exit(1)
        }

    }

    // Either the final Zeros or final Ones won't have been added during the for loop
    if zerosCounter != 0 {
        let zeros = String(repeating: ("0" as Character), count: zerosCounter)
        result+=zeros
        zerosCounter = 0
    } else if onesCounter != 0 {
        let ones = String(repeating: ("0" as Character), count: onesCounter)
        result+=ones
        onesCounter = 0
    }

    return result
}

let bMESSAGE = stringToBinaryString(myString: MESSAGE)

let uMESSAGE = binaryToUnary(myBinary: bMESSAGE)

print("MESSAGE = \(MESSAGE)", to: &errStream)

print("bMESSAGE = \(bMESSAGE)", to: &errStream)

print(uMESSAGE)
