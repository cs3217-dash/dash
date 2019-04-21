//
//  Point.swift
//  Dash
//
//  Created by Jie Liang Ang on 2/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

/**
 A `Point` describes a point on a x-y plane
 */
struct Point {
    var xVal: Int
    var yVal: Int
    var grad: Double = 0.0

    func gradient(with point: Point) -> Double {
        return Double(point.yVal - self.yVal) / Double(point.xVal - self.xVal)
    }

    init(xVal: Int, yVal: Int) {
        self.xVal = xVal
        self.yVal = yVal
    }

    init(xVal: Int, yVal: Int, grad: Double) {
        self.xVal = xVal
        self.yVal = yVal
        self.grad = grad
    }
}
