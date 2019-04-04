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

    var count: Int {
        return points.count
    }

    mutating func append(xVal: Int, yVal: Int) {
        let point = Point(xVal: xVal, yVal: yVal)
        points.append(point)
    }

    mutating func append(point: Point) {
        points.append(point)
    }

    func generateBezierPath() -> UIBezierPath {
        return UIBezierPath(points: points)
    }

    func shift(by amount: Int) -> Path {
        let shiftedPoints = points.map {
            return Point(xVal: $0.xVal, yVal: $0.yVal + amount)
        }
        return Path(points: shiftedPoints)
    }

    private func checkRep() -> Bool {
        for index in 0..<(points.count - 1)
            where points[index].xVal > points[index+1].xVal {
                return false
        }
        return true
    }
}
