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

    let topCap = Constants.pathTopCap
    let botCap = Constants.pathBotCap
    let topSmoothCap = Constants.pathTopSmoothCap
    let botSmoothCap = Constants.pathBotSmoothCap
    let interval = Constants.pathInterval

    var gradMax = 4.0
    var smoothing = false
    var currentState: PathState = .up
    var switchProb = 85

    func generateModel(startingPt: Point, startingGrad: Double, prob: Double, range: Int) -> Path {
        switchProb = Int(prob * 100.0)

        var path = Path()
        path.append(point: startingPt)

        var currentX = startingPt.xVal
        var currentY = startingPt.yVal
        var currentGrad = startingPt.grad

        let endX = currentX + range

        while currentX < endX {
            let nextPoint: Point
            if smoothing {
                let nextState = decideState(currentY: currentY, currentGradient: currentGrad, currentState: currentState)

                nextPoint = generateNextPoint(currX: currentX, currY: currentY, currGrad: currentGrad,
                                                  currState: nextState, endX: endX)

                currentX = nextPoint.xVal
                currentY = nextPoint.yVal
                currentGrad = nextPoint.grad
                currentState = nextState
            } else {
                nextPoint = generateNextArrowPoint(currX: currentX, currY: currentY,
                                                   currState: currentState, endX: endX)
                currentState = (currentState == .up) ? .down: .up
                currentX = nextPoint.xVal
                currentY = nextPoint.yVal
            }
            path.append(point: nextPoint)
        }
        path.length = range

        return path
    }

    private func generateNextArrowPoint(currX: Int, currY: Int, currState: PathState, endX: Int) -> Point {
        var grad = 1.0
        var maxX = currX + interval
        switch currState {
        case .down:
            grad = 1.0
            maxX = currX + Int((Double(topCap - currY))/grad)
        case .up:
            grad = -1.0
            maxX = currX + Int((Double(botCap - currY))/grad)
        default:
            break
        }
        let nextX = min(Int.random(in: (currX + interval)...maxX, using: &generator), endX)
        let nextY = currY + Int(grad * Double(nextX - currX))
        return Point(xVal: nextX, yVal: nextY)
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

    private func decideState(currentY: Int, currentGradient: Double, currentState: PathState) -> PathState {
        let val = Int.random(in: 0...100, using: &generator)
        switch currentState {
        case .up:
            if currentY >= topCap {
                return .stay
            }
            if currentY >= topSmoothCap && currentGradient > 0.5 {
                return .smooth
            }
            return val < switchProb ? .up : .smooth
        case .down:
            if currentY <= botCap {
                return .stay
            }
            if currentY <= botSmoothCap && currentGradient < -0.5 {
                return .smooth
            }
            return val < switchProb ? .down : .smooth
        case .stay:
            if val < 10 {
                return .stay
            } else if currentY > Constants.pathTopSmoothCap {
                return .down
            } else if currentY < Constants.pathBotSmoothCap {
                return .up
            } else {
                return val < 55 ? .up : .down
            }
        case .smooth:
            if currentGradient > 0.5 || currentGradient < -0.5 {
                return .smooth
            } 
            if currentY > Constants.gameHeight / 2 {
                return val < 10 ? .up : .down
            } else {
                return val < 10 ? .down : .up
            }
        }
    }
}
