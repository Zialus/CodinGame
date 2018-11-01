import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()


/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

let factoryCount = Int(readLine()!)! // the number of factories

var graphDistancesMatrix: [[Int]] = Array(repeating: Array(repeating: 0, count: factoryCount), count: factoryCount) // matrix to store the distances between the nodes in the graph

let linkCount = Int(readLine()!)! // the number of links between factories

if linkCount > 0 {
    for i in 0...(linkCount-1) {
        let inputs = (readLine()!).characters.split{$0 == " "}.map(String.init)
        let factory1 = Int(inputs[0])!
        let factory2 = Int(inputs[1])!
        let distance = Int(inputs[2])!
        graphDistancesMatrix[factory1][factory2] = distance
        graphDistancesMatrix[factory2][factory1] = distance
    }
}

print(graphDistancesMatrix, to: &errStream)

// game loop
while true {

    var myFactories = [(id: Int, numberOfTroops: Int)]()
    var enemyFactories = [(id: Int, numberOfTroops: Int)]()
    var neutralFactories = [(id: Int, numberOfTroops: Int)]()

    var myTroops = [(leaving: Int, goingTo: Int, numberOfTroops: Int, turnsLeftToArrive: Int)]()
    var enemyTroops = [(leaving: Int, goingTo: Int, numberOfTroops: Int, turnsLeftToArrive: Int)]()

    let entityCount = Int(readLine()!)! // the number of entities (e.g. factories and troops)
    if entityCount > 0 {
        for i in 0...(entityCount-1) {
            let inputs = (readLine()!).characters.split{$0 == " "}.map(String.init)
            let entityId = Int(inputs[0])!
            let entityType = inputs[1]
            let arg1 = Int(inputs[2])!
            let arg2 = Int(inputs[3])!
            let arg3 = Int(inputs[4])!
            let arg4 = Int(inputs[5])!
            let arg5 = Int(inputs[6])!

            switch entityType{
            case "FACTORY":
                switch arg1{
                case 1:
                    myFactories.append((id:entityId, numberOfTroops:arg2))
                case -1:
                    enemyFactories.append((id:entityId, numberOfTroops:arg2))
                case 0:
                    neutralFactories.append((id:entityId, numberOfTroops:arg2))
                default:
                    break // should never happen anyway
                }
            case "TROOP":
                switch arg1{
                case 1:
                    myTroops.append((leaving: arg2, goingTo: arg3, numberOfTroops: arg4, turnsLeftToArrive: arg5))
                case -1:
                    enemyTroops.append((leaving: arg2, goingTo: arg3, numberOfTroops: arg4, turnsLeftToArrive: arg5))
                default:
                    break // should never happen anyway
                }
            default:
                break // should never happen anyway
            }

        }
    }

    let neutralFactoriesIds = neutralFactories.map{$0.id}
    let enemyFactoriesIds = enemyFactories.map{$0.id}


    if !neutralFactoriesIds.isEmpty {

        myFactories.sort{$0.numberOfTroops > $1.numberOfTroops} // I want to know which of my factories has the highest amount of troops
        let myfactoryWithMostTrops = myFactories[0].id

        neutralFactories.sort{$0.numberOfTroops > $1.numberOfTroops} // I want to know which of the neutral factories has the least troops
        let neutralfactoryWithMostTrops = neutralFactories[0].id

        for factory in neutralFactoriesIds {
            print("MOVE \(myfactoryWithMostTrops) \(factory) 4", terminator:";")
        }
        print("WAIT")
    }

    else if !enemyFactories.isEmpty {

        myFactories.sort{$0.numberOfTroops > $1.numberOfTroops} // I want to know which of my factories has the highest amount of troops

        let myfactoryWithMostTrops: Int
        if myFactories[0].id != nil {
            myfactoryWithMostTrops = myFactories[0].id
        } else {
            myfactoryWithMostTrops = 0
        }

        enemyFactories.sort{$0.numberOfTroops < $1.numberOfTroops} // I want to know which of the enemy factories has the least troops
        let enemyfactoryWithLeastTrops = enemyFactories[0].id

        for factory in enemyFactoriesIds {
            print("MOVE \(myfactoryWithMostTrops) \(factory) 10", terminator:";")
        }
        print("WAIT")

    }

    else{
        print("WAIT")
    }
    
    // Any valid action, such as "WAIT" or "MOVE source destination cyborgs"
}

