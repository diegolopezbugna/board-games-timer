//
//  BggModels.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 31/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class BggPlays: Codable {
    var play: [BggPlay]?
    var page: Int
}

class BggPlay: Codable {
    var date: String
    var item: BggPlayGame
    var length: Int
    var location: String?
    var comments: String?
    var players: BggPlayPlayers?
    var nowinstats: Bool = false
}

class BggPlayPlayers: Codable {
    var player: [BggPlayPlayerDetails]?
}

class BggPlayPlayerDetails: Codable {
    var username: String
    var userid: Int
    var name: String
    var startposition: String
    var color: String
    var score: String
    var new: Bool
    var rating: String
    var win: Bool
}

class BggPlayGame: Codable {
    var objectid: Int
    var name: String
}
