//
//  StartNewPlayUseCase.swift
//  BoardGamesTimer
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import Foundation

protocol StartNewPlayUseCaseProtocol {
    var completionSuccess: (() -> Void)? { get set }
    var completionError: (() -> Void)? { get set }
    func execute()
}

class StartNewPlayUseCase: StartNewPlayUseCaseProtocol {
    var completionSuccess: (() -> Void)?
    var completionError: (() -> Void)?

    func execute() {
        
    }
}
