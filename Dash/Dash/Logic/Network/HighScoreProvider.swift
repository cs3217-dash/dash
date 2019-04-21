//
//  HighScoreProvider.swift
//  Dash
//
//  Created by Ang YC on 14/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

protocol HighScoreProvider {
    var limit: Int { get set }
    init(limit: Int)
    func setHighScore(_ record: HighScoreRecord, category: HighScoreCategory,
                      onDone: (() -> Void)?)
    func getHighScore(category: HighScoreCategory, onDone: (([HighScoreRecord]) -> Void)?)
}
