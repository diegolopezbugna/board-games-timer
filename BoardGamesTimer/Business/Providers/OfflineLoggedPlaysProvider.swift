//
//  OfflineLoggedPlaysProvider.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 30/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol OfflineLoggedPlaysProviderProtocol {
    func getOfflineLoggedPlays() -> [LoggedPlay]
    func addOrUpdateOfflineLoggedPlay(_ play: LoggedPlay)
}

class OfflineLoggedPlaysProvider: OfflineLoggedPlaysProviderProtocol {
    func getOfflineLoggedPlays() -> [LoggedPlay] {
        if let data = UserDefaults.standard.data(forKey: "plays"),
            let plays = NSKeyedUnarchiver.unarchiveObject(with: data) as? [LoggedPlay] {
            return plays
        }
        return []
    }
    
    func addOrUpdateOfflineLoggedPlay(_ play: LoggedPlay) {
        var allPlays = getOfflineLoggedPlays()
        if let index = allPlays.firstIndex(where: { $0.date == play.date }) {
            allPlays[index] = play
        } else {
            allPlays.append(play)
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: allPlays)
        UserDefaults.standard.set(data, forKey: "plays")
    }
}
