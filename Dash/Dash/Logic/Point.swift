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
}
