//
//  Path.swift
//  Dash
//
//  Created by Jie Liang Ang on 4/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import UIKit

struct Path {
    var points = [Point]()
    var minY = Constants.gameHeight
    var length = 0

    init() {
        points = [Point]()
    }

    init(points: [Point], length: Int) {
        self.points = points
        self.length = length
    }

    var count: Int {
        return points.count
    }

    var lastPoint: Point {
        guard let last = points.last else {
            return Point(xVal: 0, yVal: Constants.gameHeight / 2)
        }
        return last
    }

    mutating func append(xVal: Int, yVal: Int) {
        let point = Point(xVal: xVal, yVal: yVal)
        points.append(point)
        minY = min(minY, yVal)
    }

    mutating func append(point: Point) {
        points.append(point)
        minY = min(minY, point.yVal)
    }

    func generateBezierPath() -> UIBezierPath {
        return UIBezierPath(points: points)
    }

    func shift(by amount: Int) -> Path {
        let shiftedPoints = points.map {
            return Point(xVal: $0.xVal, yVal: $0.yVal + amount)
        }
        return Path(points: shiftedPoints, length: length)
    }

    func getPointAt(xVal: Int) -> Int {

        var index = 1
        while index < count && points[index].xVal < xVal {
            index += 1
        }

        let leftPt = points[index - 1]
        let rightPt = points[index]
        let gradient = leftPt.gradient(with: rightPt)
        let yVal = Int(gradient * Double(xVal - leftPt.xVal)) + leftPt.yVal

        return yVal
    }

    func getAllPointsFrom(from fromVal: Int, to toVal: Int) -> [Point] {
        var result = [Point]()

        guard count >= 2 else {
            return result
        }
        guard fromVal > 0 else {
            return result
        }

        // Get start point
        var index = 1
        while index < count && points[index].xVal <= fromVal {
            index += 1
        }
        var leftPt = points[index - 1]
        var rightPt = points[index]
        var gradient = leftPt.gradient(with: rightPt)
        var yVal = Int(gradient * Double(fromVal - leftPt.xVal)) + leftPt.yVal
        let startingPt = Point(xVal: fromVal, yVal: yVal)

        result.append(startingPt)

        // Get middle point
        while index < count && points[index].xVal <= toVal {
            result.append(points[index])
            index += 1
        }

        guard index < count else {
            return result
        }

        // Get final point
        leftPt = points[index - 1]
        rightPt = points[index]
        gradient = leftPt.gradient(with: rightPt)
        yVal = Int(gradient * Double(toVal - leftPt.xVal)) + leftPt.yVal
        let endingPt = Point(xVal: toVal, yVal: yVal)

        result.append(endingPt)

        return result
    }

    func close(top: Bool) -> Path {
        guard count > 0 else {
            return Path()
        }
        var newPoints = points
        let yVal = top ? Constants.gameHeight + 20 : -20
        newPoints.insert(Point(xVal: points[0].xVal, yVal: yVal), at: 0)
        //newPoints.append(Point(xVal: points[count-1].xVal + 5, yVal: points[count-1].yVal))
        newPoints.append(Point(xVal: points[count-1].xVal, yVal: yVal))
        return Path(points: newPoints, length: length)
    }

    private func checkRep() -> Bool {
        for index in 0..<(points.count - 1)
            where points[index].xVal > points[index+1].xVal {
                return false
        }
        return true
    }
}
