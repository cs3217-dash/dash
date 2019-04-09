//
//  PathGeneratorV2.swift
//  Dash
//
//  Created by Jie Liang Ang on 28/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import GameplayKit

enum PathState: String {
    case up
    case down
    case stay
    case smooth
}

class PathGeneratorV2 {
    
    var generator: SeededGenerator
    
    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }
    
    let topCap = Constants.gameHeight - 50
    let botCap = 50

    let topSmoothCap = Constants.gameHeight - 150
    let botSmoothCap = 150

    let interval = 50
    let gradMax = 4.0

    func generateModel(startingPt: Point, startingGrad: Double, switchProb: Double, range: Int) -> Path {
        var path = Path()
        path.append(point: startingPt)

        var currentX = startingPt.xVal
        var currentY = startingPt.yVal
        var currentGrad = startingPt.grad
        var currentState: PathState = .smooth

        let endX = currentX + range

        while currentX < endX {
            let nextState = decideState(currentY: currentY, currentGradient: currentGrad, currentState: currentState)

            let nextPoint = generateNextPoint(currX: currentX, currY: currentY, currGrad: currentGrad,
                                              currState: nextState, endX: endX)

            currentX = nextPoint.xVal
            currentY = nextPoint.yVal
            currentGrad = nextPoint.grad
            currentState = nextState
            path.append(point: nextPoint)
        }
        path.length = range
        
        return path
    }
    
    private func generateNextPoint(currX: Int, currY: Int, currGrad: Double, currState: PathState, endX: Int) -> Point {
        var grad = currGrad
        
        switch currState {
        case .smooth:
            if currGrad > 0 {
                grad = max(grad - 0.1, 0)
            } else if currGrad < 0 {
                grad = min(grad + 0.1, 0)
            }
        case .up:
            grad = min(grad + 0.1, gradMax)
        case .down:
            grad = max(grad - 0.1, -gradMax)
        case .stay:
            grad = 0.0
        }
        //print("curr: \(currGrad), new: \(grad)")

        let nextX = min(currX + interval, endX)

        var nextY = currY + Int(grad * Double(nextX - currX))
        if nextY > topCap {
            nextY = topCap
        } else if nextY < botCap {
            nextY = botCap
        }
        return Point(xVal: nextX, yVal: nextY, grad: grad)
    }

    func makePath(arr: [Point]) -> UIBezierPath {
        return UIBezierPath(points: arr)
    }

    func decideState(currentY: Int, currentGradient: Double, currentState: PathState) -> PathState {
        let val = Int.random(in: 0...100, using: &generator)
        switch currentState {
        case .up:
            if currentY >= topCap {
                return .stay
            }
            if currentY >= topSmoothCap && currentGradient > 0.5 {
                return .smooth
            }
            if val < 85 {
                return .up
            } else {
                return .smooth
            }
        case .down:
            if currentY <= botCap {
                return .stay
            }
            if currentY <= botSmoothCap && currentGradient < -0.5 {
                return .smooth
            }
            if val < 85 {
                return .down
            } else {
                return .smooth
            }
        case .stay:
            if val < 10 {
                return .stay
            } else if currentY < Constants.gameHeight / 2 {
                return .up
            } else {
                return .down
            }
        case .smooth:
            if currentGradient > 0.1 || currentGradient < -0.1 {
                return .smooth
            }
            if currentY > Constants.gameHeight / 2 {
                if val < 10 {
                    return .up
                } else {
                    return .down
                }
            } else {
                if val < 10 {
                    return .down
                } else {
                    return .up
                }
            }
        }
    }
}
