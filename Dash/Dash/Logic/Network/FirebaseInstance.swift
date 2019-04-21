//
//  FirebaseInstance.swift
//  Dash
//
//  Created by Ang YC on 14/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation
import Firebase

class FirebaseInstance {
    static let ref = FirebaseInstance().ref
    let ref: DatabaseReference

    private init() {
        FirebaseApp.configure()
        self.ref = Database.database().reference()
    }
}
