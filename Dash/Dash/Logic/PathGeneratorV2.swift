//
//  PathGeneratorV2.swift
//  Dash
//
//  Created by Jie Liang Ang on 28/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit
import GameplayKit

/// Player state within path which mimics player control
enum PathState: String {
    case up
    case down
    case stay
    case smooth
}

/**
 `PathGeneratorV2` handles generation of `Path`
 */
class PathGeneratorV2 {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    let topCap = Constants.pathTopCap
    let botCap = Constants.pathBotCap
    let smoothGradientTopCap = 0.8
    let smoothGradientBotCap = 0.4

    var topSmoothCap = Constants.pathTopSmoothCap
    var botSmoothCap = Constants.pathBotSmoothCap
    var interval = Constants.pathInterval
    var stayProbability = 0.2

    var gradMax = 4.0
    var smoothing = false
    var currentState: PathState = .up
    private var switchProb = 85
    
    /// Generate path model based on path required parameters
    /// - Parameters:
    ///     - startingPt: first point of the path
    ///     - startingGrad: initial gradient of the path
    ///     - prob: probability of switching controls/direction (hold, release)
    ///     - range: length of Path
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
                currentGrad = nextPoint.grad
                currentState = nextState
            } else {
                nextPoint = generateNextArrowPoint(currX: currentX, currY: currentY,
                                                   currState: currentState, endX: endX)
                currentState = (currentState == .up) ? .down: .up
            }
            currentX = nextPoint.xVal
            currentY = nextPoint.yVal
            path.append(point: nextPoint)
        }
        path.length = range

        return path
    }

    /// Decide and generate next point within the trajectory path without smoothening
    /// - Parameters:
    ///     - currX: current point x position
    ///     - currY: current point y position
    ///     - currState: current state
    ///     - endX: last possible x position within path
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
        let minX = (currX + interval) > maxX ? currX : (currX + interval)
        let nextX = min(Int.random(in: minX...maxX, using: &generator), endX)
        let nextY = currY + Int(grad * Double(nextX - currX))
        return Point(xVal: nextX, yVal: nextY)
    }

    /// Decide and generate next point within the trajectory path
    /// - Parameters:
    ///     - currX: current point x position
    ///     - currY: current point y position
    ///     - currGrad: current gradient
    ///     - currState: current state
    ///     - endX: last possible x position within path
    private func generateNextPoint(currX: Int, currY: Int, currGrad: Double, currState: PathState, endX: Int) -> Point {
        var grad = currGrad

        switch currState {
        // Adjust gradient to 0 to smoothen out curve trajectories when accelerating/decelerating
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
    
    /// Decides next PathState based on current state and switching probability
    /// - Parameters:
    ///     - currentY: current Y position in path
    ///     - currentGradient: current gradient within path
    ///     - currentState: current state within path
    private func decideState(currentY: Int, currentGradient: Double, currentState: PathState) -> PathState {
        let val = Int.random(in: 0...100, using: &generator)
        switch currentState {
        case .up:
            // Do not go further up once reach top limit
            if currentY >= topCap {
                return .stay
            }
            // If moving or accelerating upwards at certain top limit, slow down to prevent
            // character from crashing top limit when decelerating
            if currentY >= topSmoothCap && currentGradient > smoothGradientTopCap {
                return .smooth
            }
            // Either continue going up (holding) or release (smooth)
            return val > switchProb ? .up : .smooth
        case .down:
            // Do not go further down once reach bottom limit
            if currentY <= botCap {
                return .stay
            }
            // If moving or accelerating downwards at certain bottom limit, slow down to prevent
            // character from crashing bottom limit when accelerating upwards
            if currentY <= botSmoothCap && currentGradient < -smoothGradientTopCap {
                return .smooth
            }
            // Either continue going down (releasing) or hold (smooth)
            return val > switchProb ? .down : .smooth
        case .stay:
            // Maintain at same position
            // Conflicts when hovering upwards and downwards is addressed by path width
            if val < Int(stayProbability * 100) {
                return .stay
            }
            // If at extreme ends, go down or up accordingly.
            else if currentY > Constants.pathTopSmoothCap {
                return .down
            } else if currentY < Constants.pathBotSmoothCap {
                return .up
            }
            // Go up or down
            else {
                return val < Int((1-stayProbability)*100)/2 ? .up : .down
            }
        case .smooth:
            // Continue smoothing
            if currentGradient > smoothGradientBotCap || currentGradient < -smoothGradientBotCap {
                return .smooth
            }
            // Finish smoothing. Proceed to stay.
            return .stay
        }
    }

    func makePath(arr: [Point]) -> UIBezierPath {
        return UIBezierPath(points: arr)
    }
}
