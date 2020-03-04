//
//  HomeViewModelTests.swift
//  TripsTests
//
//  Created by AGUJARI Erik on 04/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
@testable import Trips

final class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModelProtocol! = nil

    override func setUp() {
        super.setUp()
        sut = HomeViewModel(dependencies: MockHomeViewModelDependencies())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testTripsSuccess() {
        sut.retrieveTrips()
        XCTAssert(!sut.cellModels.isEmpty)
    }
}
