//
//  PlayPlayerDetails.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 17/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class LoggedPlayPlayerDetails: NSObject, NSCoding, Codable {
    var player: Player?
    var won: Bool?
    var firstTimePlaying: Bool?
    var score: Int?
    var teamColor: String?
    var startingPosition: String?
    var playRating: String?
    var time: TimeInterval?
    
    override init() {
        super.init()
    }
    
    convenience init(player: Player, won: Bool?, score: Int?) {
        self.init(player: player, won: won, firstTimePlaying: nil, score: score, teamColor: nil, startingPosition: nil, playRating: nil, time: nil)
    }

    init(player: Player, won: Bool?, firstTimePlaying: Bool?, score: Int?, teamColor: String?, startingPosition: String?, playRating: String?, time: TimeInterval?) {
        self.player = player
        self.won = won
        self.firstTimePlaying = firstTimePlaying
        self.score = score
        self.teamColor = teamColor
        self.startingPosition = startingPosition
        self.playRating = playRating
        self.time = time
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.player, forKey: "player");
        aCoder.encode(self.won, forKey: "won");
        aCoder.encode(self.firstTimePlaying, forKey: "firstTimePlaying");
        aCoder.encode(self.score, forKey: "score");
        aCoder.encode(self.teamColor, forKey: "teamColor");
        aCoder.encode(self.startingPosition, forKey: "startingPosition");
        aCoder.encode(self.playRating, forKey: "playRating");
        aCoder.encode(self.time, forKey: "time");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.player = aDecoder.decodeObject(forKey: "player") as? Player
        self.won = aDecoder.decodeObject(forKey: "won") as? Bool
        self.firstTimePlaying = aDecoder.decodeObject(forKey: "firstTimePlaying") as? Bool
        self.score = aDecoder.decodeObject(forKey: "score") as? Int
        self.teamColor = aDecoder.decodeObject(forKey: "teamColor") as? String
        self.startingPosition = aDecoder.decodeObject(forKey: "startingPosition") as? String
        self.playRating = aDecoder.decodeObject(forKey: "playRating") as? String
        self.time = aDecoder.decodeObject(forKey: "time") as? TimeInterval
        super.init()
    }
}
