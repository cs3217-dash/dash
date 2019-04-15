//
//  LocalHighScoreProvider.swift
//  Dash
//
//  Created by Ang YC on 14/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

class LocalHighScoreProvider: HighScoreProvider {
    var limit: Int

    required init(limit: Int) {
        self.limit = limit
    }

    func setHighScore(_ record: HighScoreRecord, category: HighScoreCategory,
                      onDone: (() -> Void)?) {
        let localHighScores = Storage.getLocalHighScore(forCategory: category)
        let added = localHighScores + [record]
        let sorted = added.sorted { $0.score > $1.score }
        let top = Array(sorted.prefix(limit))
        Storage.saveLocalHighScore(top, forCategory: category)
        onDone?()
    }

    func getHighScore(category: HighScoreCategory, onDone: (([HighScoreRecord]) -> Void)?) {
        let localHighScores = Storage.getLocalHighScore(forCategory: category)
        print(localHighScores)
        let sorted = localHighScores.sorted { $0.score > $1.score }
        print(sorted)
        let top = Array(sorted.prefix(limit))
        onDone?(top)
    }
}
