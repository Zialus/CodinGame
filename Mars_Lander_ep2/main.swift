import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

var prevLandX = 0
var prevLandY = 0

var landingLeftMargin = 0
var landingRightMargin = 0

let surfaceN = Int(readLine()!)! // the number of points used to draw the surface of Mars.

var pointsList = [(Int,Int)]()

for i in 0...(surfaceN-1) {
    let inputs = (readLine()!).characters.split{$0 == " "}.map(String.init)
    let landX = Int(inputs[0])! // X coordinate of a surface point. (0 to 6999)
    let landY = Int(inputs[1])! // Y coordinate of a surface point. By linking all the points together in a sequential fashion, you form the surface of Mars.

    pointsList.append((landX,landY))

    if landY == prevLandY {
        landingLeftMargin = prevLandX
        landingRightMargin = landX
    }

    prevLandX = landX
    prevLandY = landY

}

let borderHeight = 3000

let maxHeight = pointsList.map{$0.1}.max()!

let cursingHeight = (borderHeight + maxHeight)/2

let landingCenter = (landingRightMargin + landingLeftMargin)/2

print("landingLeftMargin \(landingLeftMargin), landingRightMargin \(landingRightMargin), landingCenter: \(landingCenter), cursingHeight: \(cursingHeight)", to: &errStream)

// game loop
while true {
    let inputs = (readLine()!).characters.split{$0 == " "}.map(String.init)
    let X = Int(inputs[0])!
    let Y = Int(inputs[1])!
    let hSpeed = Int(inputs[2])! // the horizontal speed (in m/s), can be negative.
    let vSpeed = Int(inputs[3])! // the vertical speed (in m/s), can be negative.
    let fuel = Int(inputs[4])! // the quantity of remaining fuel in liters.
    let rotate = Int(inputs[5])! // the rotation angle in degrees (-90 to 90).
    let power = Int(inputs[6])! // the thrust power (0 to 4).

    let insideLandingArea = (X > landingLeftMargin && X < landingRightMargin)
    let outsideLandingArea = !insideLandingArea
    let horizontalSpeedTooHigh = abs(hSpeed) >= 18
    let horizontalSpeedTooHighCriticalZone = abs(hSpeed) >= 10
    let verticalSpeedTooHigh = abs(vSpeed) >= 38
    let verticalSpeedTooHighCriticalZone = abs(vSpeed) >= 30
    let horizontalSpeedLimit = 30
    let verticalSpeedLimit = 50
    let horizontal: Int
    let thrust: Int

    let distanceToCenter = X - landingCenter
    let distanceToCursingHeight = Y - cursingHeight

    print("landingLeftMargin \(landingLeftMargin), landingRightMargin \(landingRightMargin), landingCenter: \(landingCenter), cursingHeight: \(cursingHeight)", to: &errStream)

    if outsideLandingArea {

        if distanceToCursingHeight < 0 && vSpeed < -10 {

            if X < landingLeftMargin {
                horizontal = -10
            } else {
                horizontal = 10
            }
            thrust = 4
        } else {

            if X < landingLeftMargin && hSpeed < 30 {
                horizontal = -45
                if vSpeed < -40 {
                    thrust = 4
                } else {
                    thrust = 3
                }

            } else if X > landingRightMargin && hSpeed > -30 {
                horizontal = 45
                if vSpeed < -40 {
                    thrust = 4
                } else {
                    thrust = 3
                }

            } else {

                if hSpeed < -35 {
                    horizontal = -45
                    thrust = 4
                } else if hSpeed > 35 {
                    horizontal = 45
                    thrust = 4
                } else if vSpeed < 10 {
                    horizontal = 0
                    thrust = 4
                } else {
                    horizontal = 0
                    thrust = 3
                }

            }

        }

    } else {

        if horizontalSpeedTooHighCriticalZone {

            if hSpeed > 0 {
                horizontal = 45
            } else {
                horizontal = -45
            }

            thrust = 4

        } else if verticalSpeedTooHighCriticalZone {
            horizontal = 0
            thrust = 4
        } else {
            horizontal = 0
            thrust = 2
        }
    }

    // rotate power. rotate is the desired rotation angle. power is the desired thrust power.
    print("\(horizontal) \(thrust)")
}
