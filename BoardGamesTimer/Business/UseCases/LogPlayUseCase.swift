//
//  LogPlayUseCase.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol LogPlayUseCaseProtocol {
    var completionSuccess: (() -> Void)? { get set }
    var completionError: (() -> Void)? { get set }
    func execute(play: LoggedPlay)
}

class LogPlayUseCase: LogPlayUseCaseProtocol {
    var completionSuccess: (() -> Void)?
    var completionError: (() -> Void)?
    
    let offlineLoggedPlaysProvider: OfflineLoggedPlaysProviderProtocol
    
    init(offlineLoggedPlaysProvider: OfflineLoggedPlaysProviderProtocol) {
        self.offlineLoggedPlaysProvider = offlineLoggedPlaysProvider
    }
    
    func execute(play: LoggedPlay) {
        offlineLoggedPlaysProvider.addOrUpdateOfflineLoggedPlay(play)
        completionSuccess?()
    }
}
