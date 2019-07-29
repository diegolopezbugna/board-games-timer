//
//  GetBggUsernameUseCaseTests.swift
//  BoardGamesTimerTests
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import XCTest
@testable import BoardGamesTimer

class StubBggUsernameProvider: BggUsernameProviderProtocol {
    var bggUsername: String?
}

class GetBggUsernameUseCaseTests: XCTestCase {

    func testGivenUsernameFilledThenShouldGetUsername() {
        // GIVEN
        let stubProvider = StubBggUsernameProvider()
        stubProvider.bggUsername = "test"
        let useCase = GetBggUsernameUseCase(bggUsernameProvider: stubProvider)
        // WHEN
        useCase.completionSuccess = { (bggUsername) in
            // THEN
            XCTAssert(bggUsername == "test")
        }
        useCase.execute()
    }

    func testGivenUsernameEmptyThenShouldGetEmptyUsername() {
        // GIVEN
        let stubProvider = StubBggUsernameProvider()
        stubProvider.bggUsername = nil
        let useCase = GetBggUsernameUseCase(bggUsernameProvider: stubProvider)
        // WHEN
        useCase.completionSuccess = { (bggUsername) in
            // THEN
            XCTAssert(bggUsername == nil)
        }
        useCase.execute()
    }
    
}
