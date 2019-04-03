//
//  StageManager.swift
//  Dash
//
//  Created by Jolyn Tan on 29/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class StageManager {
    var currentStage: Stage = Stage(id: 0)

    func shouldStageChange(at currentDistance: Double) -> Bool {
        return currentDistance > currentStage.endDistance
    }

    func onStageChange(previousStage: Stage) {
        // get next stage
       // let nextStage = previousStage.nextStage

        // update parameters
        //currentStage = nextStage
    }
}
