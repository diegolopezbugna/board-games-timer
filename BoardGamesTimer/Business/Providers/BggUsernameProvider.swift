//
//  BggUsernameProvider.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol BggUsernameProviderProtocol {
    var bggUsername: String? { get set }
}

class BggUsernameProvider: BggUsernameProviderProtocol {
    var bggUsername: String? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.Keys.bggUsername.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.bggUsername.rawValue)
        }
    }
}
