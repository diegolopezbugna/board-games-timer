//
//  SaveBggUsernameUseCaseTests.swift
//  BoardGamesTimerTests
//
//  Created by Diego Lopez bugna on 25/07/2019.
//  Copyright © 2019 Diego. All rights reserved.
//

import XCTest
@testable import BoardGamesTimer

class SaveBggUsernameUseCaseTests: XCTestCase {
    func testShouldSaveBggUsername() {
        // GIVEN
        let stubProvider = StubBggUsernameProvider()
        let useCase = SaveBggUsernameUseCase(bggUsernameProvider: stubProvider)
        // WHEN
        useCase.execute(bggUsername: "test")
        // THEN
        XCTAssert(stubProvider.bggUsername == "test")
    }
    
    func testShouldSaveEmptyBggUsername() {
        // GIVEN
        let stubProvider = StubBggUsernameProvider()
        stubProvider.bggUsername = "test"
        let useCase = SaveBggUsernameUseCase(bggUsernameProvider: stubProvider)
        // WHEN
        useCase.execute(bggUsername: nil)
        // THEN
        XCTAssert(stubProvider.bggUsername == nil)
    }

}
