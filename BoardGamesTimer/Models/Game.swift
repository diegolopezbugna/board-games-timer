//
//  Game.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 23/3/19.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

class Game: NSObject, NSCoding, Codable {
    
    var id: Int!
    var name: String?
    var thumbnailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "objectid"
        case name
    }
    
    override init() {
        super.init()
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id");
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.thumbnailUrl, forKey: "thumbnailUrl");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.thumbnailUrl = aDecoder.decodeObject(forKey: "thumbnailUrl") as? String
        super.init()
    }
    
    override var description: String { return "{ Game: id:\(id ?? 0) name:\(name ?? "") }" }
}
