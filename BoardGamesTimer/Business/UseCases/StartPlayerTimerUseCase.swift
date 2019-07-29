//
//  StartPlayerTimerUseCase.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol StartPlayerTimerUseCaseProtocol {
    var completionSuccess: (() -> Void)? { get set }
    var completionError: (() -> Void)? { get set }
    func execute(bggUsername: String?)
}

class StartPlayerTimerUseCase: StartPlayerTimerUseCaseProtocol {
    var completionSuccess: (() -> Void)?
    var completionError: (() -> Void)?

    func execute(bggUsername: String?) {
        
    }
}
