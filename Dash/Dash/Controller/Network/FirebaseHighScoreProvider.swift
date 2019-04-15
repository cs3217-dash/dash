//
//  FirebaseHighScoreProvider.swift
//  Dash
//
//  Created by Ang YC on 14/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHighScoreProvider: HighScoreProvider {
    var limit: Int
    let ref: DatabaseReference

    required init(limit: Int) {
        self.limit = limit
        ref = FirebaseInstance.ref
    }

    func setHighScore(_ record: HighScoreRecord, category: HighScoreCategory, onDone: (() -> Void)?) {
        let highScoreRef = ref.child("highscores").child(category.rawValue)
        let childRef = highScoreRef.childByAutoId()

        guard let dict = record.dictionary else {
            return
        }
        childRef.setValue(dict)
        onDone?()
    }

    func getHighScore(category: HighScoreCategory, onDone: (([HighScoreRecord]) -> Void)?) {
        ref.child("highscores").child(category.rawValue)
            .queryOrdered(byChild: "score").queryLimited(toLast: UInt(limit))
            .observeSingleEvent(of: .value) { (snapshot) in
                guard let dict = snapshot.value as? [String: Any?] else {
                    return
                }
                let records: [HighScoreRecord] = dict.compactMap { (arg) in
                    let (_, dict2) = arg
                    guard let dict3 = dict2 as? [String: Any] else {
                        return nil
                    }
                    return HighScoreRecord(dict: dict3)
                }
                let sorted = records.sorted { $0.score > $1.score }
                onDone?(sorted)
        }
    }
}
