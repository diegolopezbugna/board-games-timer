//
//  GetLoggedPlaysUseCase.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol GetLoggedPlaysUseCaseProtocol {
    var completionSuccess: (([LoggedPlay]) -> Void)? { get set }
    var completionError: (() -> Void)? { get set }
    func execute()
}

class GetLoggedPlaysUseCase: GetLoggedPlaysUseCaseProtocol {
    var completionSuccess: (([LoggedPlay]) -> Void)?
    var completionError: (() -> Void)?
    
    let offlineLoggedPlaysProvider: OfflineLoggedPlaysProviderProtocol
    let bggLoggedPlaysProvider: BggLoggedPlaysProviderProtocol
    var getBggUsernameUseCase: GetBggUsernameUseCaseProtocol
    
    
    init(offlineLoggedPlaysProvider: OfflineLoggedPlaysProviderProtocol,
         bggLoggedPlaysProvider: BggLoggedPlaysProviderProtocol,
         getBggUsernameUseCase: GetBggUsernameUseCaseProtocol) {
        self.offlineLoggedPlaysProvider = offlineLoggedPlaysProvider
        self.bggLoggedPlaysProvider = bggLoggedPlaysProvider
        self.getBggUsernameUseCase = getBggUsernameUseCase
    }
    
    func execute() {
        let offlinePlays = offlineLoggedPlaysProvider.getOfflineLoggedPlays()
        getBggUsernameUseCase.completionSuccess = { bggUsername in
            if let bggUsername = bggUsername,
                bggUsername.count > 0 {
                self.bggLoggedPlaysProvider.getBggLoggedPlays(username: bggUsername) { (plays) in
                    if let onlinePlays = plays {
                        var allPlays = offlinePlays
                        allPlays.append(contentsOf: onlinePlays)
                        self.completionSuccess?(allPlays)
                    }
                }
            } else {
                self.completionSuccess?(offlinePlays)
            }
        }
        getBggUsernameUseCase.execute()
    }
}
