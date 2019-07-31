//
//  OfflineLoggedPlaysProvider.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 30/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol BggLoggedPlaysProviderProtocol {
    func getBggLoggedPlays(username: String, callback: @escaping ([LoggedPlay]?) -> Void)
}

class BggLoggedPlaysProvider: BggLoggedPlaysProviderProtocol {
    func getBggLoggedPlays(username: String, callback: @escaping ([LoggedPlay]?) -> Void) {
        return self.getBggPlays(username: username, page: 1, previousPlays: nil, callback: callback)
    }
    
    private func getBggPlays(username: String, page: Int, previousPlays: [LoggedPlay]? = nil, callback: @escaping ([LoggedPlay]?) -> Void) {
        // TODO: change to an infinite scrolling
        // https://www.raywenderlich.com/5786-uitableview-infinite-scrolling-tutorial
        let connector = PlaysConnector()
        var onlinePlays = previousPlays ?? [LoggedPlay]()
        connector.getPlays(username: username, page: page) { (plays) in
            if let plays = plays, page < 11 {
                onlinePlays.append(contentsOf: plays)
                self.getBggPlays(username: username, page: page + 1, previousPlays: onlinePlays, callback: callback)
            } else {
                callback(onlinePlays)
            }
        }
    }
}
