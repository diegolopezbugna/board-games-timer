//
//  PlayPlayerDetails.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 17/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class PlayPlayerDetails: NSObject, NSCoding {
    var player: Player?
    var won: Bool?
    var firstTimePlaying: Bool?
    var score: Int?
    var teamColor: String?
    var startingPosition: String?
    var playRating: String?
    
    override init() {
        super.init()
    }
    
    init(player: Player, won: Bool, score: Int) {
        self.player = player
        self.won = won
        self.score = score
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.player, forKey: "player");
        aCoder.encode(self.won, forKey: "won");
        aCoder.encode(self.firstTimePlaying, forKey: "firstTimePlaying");
        aCoder.encode(self.score, forKey: "score");
        aCoder.encode(self.teamColor, forKey: "teamColor");
        aCoder.encode(self.startingPosition, forKey: "startingPosition");
        aCoder.encode(self.playRating, forKey: "playRating");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.player = aDecoder.decodeObject(forKey: "player") as? Player
        self.won = aDecoder.decodeObject(forKey: "won") as? Bool
        self.firstTimePlaying = aDecoder.decodeObject(forKey: "firstTimePlaying") as? Bool
        self.score = aDecoder.decodeObject(forKey: "score") as? Int
        self.teamColor = aDecoder.decodeObject(forKey: "teamColor") as? String
        self.startingPosition = aDecoder.decodeObject(forKey: "startingPosition") as? String
        self.playRating = aDecoder.decodeObject(forKey: "playRating") as? String
        super.init()
    }
}
