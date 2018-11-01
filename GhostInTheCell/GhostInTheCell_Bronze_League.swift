import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

let factoryCount = Int(readLine()!)! // the number of factories
var graphDistancesMatrix: [[Int]] = Array(repeating: Array(repeating: 0, count: factoryCount), count: factoryCount) // matrix to store the distances between the nodes in the graph

let linkCount = Int(readLine()!)! // the number of links between factories

for i in 0...(linkCount-1) {
    let inputs = (readLine()!).characters.split{$0 == " "}.map(String.init)
    let factory1 = Int(inputs[0])!
    let factory2 = Int(inputs[1])!
    let distance = Int(inputs[2])!
    graphDistancesMatrix[factory1][factory2] = distance
    graphDistancesMatrix[factory2][factory1] = distance
}


print(graphDistancesMatrix, to: &errStream)

var beingBombed: [Bool] = Array(repeating: false, count: linkCount)

typealias factoryType = (id: Int, numberOfTroops: Int, productionPerTurn: Int)
typealias factoryList = [factoryType]
typealias troopType = (leaving: Int, goingTo: Int, numberOfTroops: Int, turnsLeftToArrive: Int)
typealias troopList = [troopType]
typealias bombType = (leaving: Int, goingTo: Int, turnsLeftToArrive: Int)
typealias bombList = [bombType]


func closestFactory(to destinationFactory: factoryType, fromList: factoryList) -> factoryType {
    var closestSource = fromList[0] // just pick the first available one as the current closest
    var minDistance = Int.max // min starts at max possible value

    for sourceFactory in fromList {
        let distance = graphDistancesMatrix[sourceFactory.id][destinationFactory.id]
        if distance < minDistance && sourceFactory.numberOfTroops > 1 {
            // change best lower distances
            minDistance = distance
            closestSource = sourceFactory
        }
    }

    return closestSource
}

func underHeavyAttack(at factory: factoryType, by enemyTroopList: troopList) -> Bool {
    var totalCyborgsAttackingThisFactory = 0

    for enemyTroop in enemyTroopList{
        if enemyTroop.goingTo == factory.id && enemyTroop.turnsLeftToArrive == 1 {
            totalCyborgsAttackingThisFactory+=enemyTroop.numberOfTroops
        }
    }

    if totalCyborgsAttackingThisFactory >= factory.numberOfTroops {
        // The factory is under heavy attack
        return true
    } else {
        return false
    }
}


var roundCounter = 0
// game loop
while true {
    roundCounter+=1

    print(roundCounter, to: &errStream)

    var myFactories = factoryList()
    var enemyFactories = factoryList()
    var neutralFactories = factoryList()

    var myTroops = troopList()
    var enemyTroops = troopList()

    var myBombs = bombList()
    var enemyBombs = bombList()

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
                    myFactories.append((id: entityId, numberOfTroops: arg2, productionPerTurn: arg3))
                case -1:
                    enemyFactories.append((id: entityId, numberOfTroops: arg2, productionPerTurn: arg3))
                case 0:
                    neutralFactories.append((id: entityId, numberOfTroops: arg2, productionPerTurn: arg3))
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
            case "BOMB":
                switch arg1{
                case 1:
                    myBombs.append((leaving: arg2, goingTo: arg3, turnsLeftToArrive: arg4))
                case -1:
                    enemyBombs.append((leaving: arg2, goingTo: arg3, turnsLeftToArrive: arg4))
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

    for factory in myFactories {

        if factory.numberOfTroops >= 40 {
            print("INC \(factory.id)", terminator: ";")
        }
    }

    if !enemyBombs.isEmpty {
        for bomb in enemyBombs {
            if bomb.turnsLeftToArrive == 2 {
                let myfactoyBeingAttackedID = bomb.goingTo
                let fakeFactoryTuple = (myfactoyBeingAttackedID,100,100)
                let moveToFactory = closestFactory(to: fakeFactoryTuple, fromList: myFactories)

                print("MOVE \(myfactoyBeingAttackedID) \(moveToFactory) 100", terminator:";")
                print("MSG SCREW YOUR BOMB", to: &errStream)
            } else {
                print("MSG I SEE YOUR BOMB", to: &errStream)
            }
        }
    }


    if myFactories.isEmpty{
        print("WAIT")
    }

    if !neutralFactoriesIds.isEmpty {

        myFactories.sort{$0.numberOfTroops > $1.numberOfTroops} // I want to sort my factories by highest troop number

        if let myfactoryWithMostTrops = myFactories.first {

            neutralFactories.sort{$0.productionPerTurn > $1.productionPerTurn} // I want to sort the neutral factories by lvl of production per turn

            print("NEUTRAL INFO \(neutralFactories)", to: &errStream)


            for factory in neutralFactories {
                for myFactory in myFactories {
                    if !underHeavyAttack(at: myFactory , by: enemyTroops) {

                        if factory.productionPerTurn != 0 {
                            print("MOVE \(myFactory.id) \(factory.id) 20", terminator:";")
                        }
                    } else {
                        print("MSG UNDER HEAVY ATTACK \(myfactoryWithMostTrops.id)",terminator:";")
                    }
                }
            }

        }
    }

    if !enemyFactories.isEmpty {

        myFactories.sort{$0.numberOfTroops > $1.numberOfTroops} // I want to know which of my factories has the highest amount of troops

        if let myfactoryWithMostTrops = myFactories.first {

            enemyFactories.sort{$0.numberOfTroops < $1.numberOfTroops} // I want to know which of the enemy factories has the least troops
            let enemyfactoryWithLeastTroops = enemyFactories.first!
            let enemyFactoryWithMostTroops = enemyFactories.last!

            for enemyFactory in enemyFactories{
                if enemyFactory.productionPerTurn >= 2 && beingBombed[enemyFactory.id] == false {
                    let sourceFactory = closestFactory(to: enemyFactory, fromList: myFactories)
                    print("BOMB \(sourceFactory.id) \(enemyFactory.id)", terminator:";")
                    beingBombed[enemyFactory.id] = true
                }
            }


            enemyFactories.sort{$0.productionPerTurn > $1.productionPerTurn} // I want to sort the enemy factories by lvl of production per turn

            print("ENEMY INFO \(enemyFactories)", to: &errStream)


            for factory in enemyFactories {
                for myFactory in myFactories {
                    if !underHeavyAttack(at: myFactory , by: enemyTroops) {

                        print("MOVE \(myFactory.id) \(factory.id) \(3+(myFactory.numberOfTroops/10))", terminator:";")
                        
                        
                    } else {
                        print("MSG UNDER HEAVY ATTACK \(myfactoryWithMostTrops.id)",terminator:";")
                    }
                }
                
            }
            
            
        }
    }
    
    print("WAIT; MSG END OF TURN")
    
}
