//
//  HomeViewModelTests.swift
//  TripsTests
//
//  Created by AGUJARI Erik on 04/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
import CoreLocation
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
        XCTAssert(!sut.isFetching)
        XCTAssert(sut.error == nil)
        sut.retrieveTrips()
        XCTAssert(!sut.stops(forTrip: 0).isEmpty)
        XCTAssert(!sut.route(forTrip: 0).isEmpty)
        XCTAssert(!sut.cellModels.isEmpty)
    }

    func testStopDetailSucess() {
        testTripsSuccess()
        XCTAssert(sut.stopDetail == nil)
        sut.retrieveStopDetail(for: CLLocationCoordinate2D(latitude: 0,
                                                           longitude: 0))
        XCTAssert(sut.stopDetail != nil)
    }

    func testStopDetailFails() {
        testTripsSuccess()
        XCTAssert(sut.stopDetail == nil)
        sut.retrieveStopDetail(for: CLLocationCoordinate2D(latitude: 0.1,
                                                           longitude: 0))
        XCTAssert(sut.stopDetail == nil)
    }

    func testIsStartSucess() {
        testTripsSuccess()
        XCTAssert(sut.isStart(coordinate: CLLocationCoordinate2D(latitude: 1,
                                                                 longitude: 1)))
        XCTAssertFalse(sut.isStart(coordinate: CLLocationCoordinate2D(latitude: 0,
                                                                      longitude: 0)))
        XCTAssertFalse(sut.isStart(coordinate: CLLocationCoordinate2D(latitude: 1.01,
                                                                      longitude: 1)))
        guard let firstStop = sut.stops(forTrip: 0).first
            else {
                XCTFail()
                return
        }
        XCTAssertFalse(sut.isStart(coordinate: firstStop))
    }

    func testIsEndSucess() {
        testTripsSuccess()
        XCTAssert(sut.isEnd(coordinate: CLLocationCoordinate2D(latitude: 3,
                                                                 longitude: 3)))
        XCTAssertFalse(sut.isEnd(coordinate: CLLocationCoordinate2D(latitude: 0,
                                                                      longitude: 0)))
        XCTAssertFalse(sut.isEnd(coordinate: CLLocationCoordinate2D(latitude: 1.01,
                                                                      longitude: 1)))
        guard let firstStop = sut.stops(forTrip: 0).first
            else {
                XCTFail()
                return
        }
        XCTAssertFalse(sut.isEnd(coordinate: firstStop))
    }
}
