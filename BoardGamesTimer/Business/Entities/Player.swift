//
//  Player.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 17/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class Player: NSObject, NSCoding, Codable {
    let id: UUID
    var name: String
    var bggUsername: String?
    var preferredColor: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id");
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.bggUsername, forKey: "bggUser");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! UUID
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.bggUsername = aDecoder.decodeObject(forKey: "bggUser") as? String
        super.init()
    }
    
    init(id: UUID, name: String, bggUsername: String?) {
        self.id = id
        self.name = name
        self.bggUsername = bggUsername
    }
}
