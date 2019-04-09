//
//  Point.swift
//  Dash
//
//  Created by Jie Liang Ang on 2/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

struct Point {
    var xVal: Int
    var yVal: Int

    func gradient(with point: Point) -> Double {
        return Double(point.yVal - self.yVal) / Double(point.xVal - self.xVal)
    }
    
    var grad: Double = 0.0
    
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
