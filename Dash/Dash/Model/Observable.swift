//
//  Observable.swift
//  Dash
//
//  Created by Jie Liang Ang on 20/3/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import Foundation

protocol Observable: class {
    var observers: [ObjectIdentifier: Observer] { get set }

    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
    func notifyObservers(name: String, object: Any?)
}

extension Observable {
    func addObserver(_ observer: Observer) {
        let oid = ObjectIdentifier(observer)
        observers[oid] = observer
    }

    func removeObserver(_ observer: Observer) {
        let oid = ObjectIdentifier(observer)
        observers.removeValue(forKey: oid)
    }

    func notifyObservers(name: String, object: Any?) {
        for (_, observer) in observers {
            observer.onValueChanged(name: name, object: object)
        }
    }
}
