//
//  Game.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 23/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class Game : Codable, CustomStringConvertible {
    
    var id: Int!
    var name: String?
    var thumbnailUrl: String?

    var description: String { return "{ Game: id:\(id ?? 0) name:\(name ?? "") }" }
}
