//
//  HomeViewModelTests.swift
//  TripsTests
//
//  Created by AGUJARI Erik on 04/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
import CoreLocation
import Combine
@testable import Trips

final class HomeViewModelTests: XCTestCase {
    func test_retrieveTripsSuccess() {
        let sut = makeSUT()
        let exp = expectation(description: "Waiting for cellModels")
        var cancellable = Set<AnyCancellable>()
        
        sut.retrieveTrips()
        sut.$cellModels.sink { cellModels in
            XCTAssertFalse(cellModels.isEmpty)
            XCTAssertNil(sut.error)
            exp.fulfill()
        }.store(in: &cancellable)
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func test_invalidTripIndex_returnsEmptyRoute() {
        expect(sut: makeSUT(), withIndex: -1, for: .route, toBeEmpty: true)
    }
    
    func test_validTripIndex_returnsNonEmptyRoute() {
        expect(sut: makeSUT(), withIndex: 0, for: .route, toBeEmpty: false)
    }
    
    func test_invalidTripIndex_returnsEmptyStop() {
        expect(sut: makeSUT(), withIndex: -1, for: .stop, toBeEmpty: true)
    }
    
    func test_validTripIndex_returnsNonEmptyStop() {
        expect(sut: makeSUT(), withIndex: 0, for: .stop, toBeEmpty: false)
    }
    
    func test_invalidRoute_hasNotStopDetail() {
        expect(sut: makeSUT(), forRoute: -50, hasDetail: false)
    }
    
    func test_validRoute_hasStopDetail() {
        expect(sut: makeSUT(), forRoute: 0, hasDetail: true)
    }
    
    func test_emptyTripsList_returnsNoStart() {
        let sut = makeSUT()
        expect(sut: sut,
               hasTripList: false,
               isTripSelected: true,
               withRoute: 0,
               validCoordinate: true,
               toSucceed: false)
    }
    
    func test_invalidRoute_returnsNoStart() {
        let sut = makeSUT()
        expect(sut: sut,
               hasTripList: true,
               isTripSelected: true,
               withRoute: 20,
               validCoordinate: true,
               toSucceed: false)
    }
    
    func test_invalidCoordinateForValidRoute_returnsNoStart() {
        let sut = makeSUT()
        expect(sut: sut,
               hasTripList: true,
               isTripSelected: true,
               withRoute: 0,
               validCoordinate: false,
               toSucceed: false)
    }
    
    func test_validRouteWithValidCoordinate_andWithoutTripSelected_returnsNoStart() {
        let sut = makeSUT()
        expect(sut: sut,
               hasTripList: true,
               isTripSelected: false,
               withRoute: 0,
               validCoordinate: true,
               toSucceed: false)
    }
    
    func test_validRouteWithValidCoordinate_andWithTripSelected_returnsStart() {
        let sut = makeSUT()
        expect(sut: sut,
               hasTripList: true,
               isTripSelected: true,
               withRoute: 0,
               validCoordinate: true,
               toSucceed: true)
    }
}

//MARK: - Helpers
extension HomeViewModelTests {
    private enum POIType {
        case route
        case stop
    }
    
    private func makeSUT() -> HomeViewModelProtocol {
        return HomeViewModel(dependencies: MockHomeViewModelDependencies())
    }
    
    private func expect(sut: HomeViewModelProtocol, withIndex index: Int, for poiType: POIType, toBeEmpty: Bool, file: StaticString = #file, line: UInt = #line) {
        sut.retrieveTrips()
        let route = poiType == .route ? sut.route(forTrip: index) : sut.stops(forTrip: index)
        
        XCTAssertEqual(route.isEmpty, toBeEmpty, file: file, line: line)
    }
    
    private func expect(sut: HomeViewModelProtocol, forRoute id: Int, hasDetail assertion: Bool, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for stopDetails")
        var cancellable = Set<AnyCancellable>()
        
        sut.retrieveTrips()
        let route = sut.route(forTrip: id).first
        sut.retrieveStopDetail(for: route ?? CLLocationCoordinate2D(latitude: -1, longitude: -1))
        sut.$stopDetail.sink { detail in
            XCTAssertEqual(assertion, detail != nil, file: file, line: line)
            exp.fulfill()
        }.store(in: &cancellable)
        
        wait(for: [exp], timeout: 0.2)
    }
    
    private func expect(sut: HomeViewModelProtocol, hasTripList: Bool, isTripSelected: Bool, withRoute index: Int, validCoordinate: Bool, toSucceed: Bool, file: StaticString = #file, line: UInt = #line) {
        let sut = makeSUT()
        guard hasTripList else {
            XCTAssertFalse(toSucceed, "Expected failure because test has no trips", file: file, line: line)
            return
        }
        
        sut.retrieveTrips()
        guard isTripSelected else {
            XCTAssertFalse(toSucceed, "Expected failure because test has no tripSelected", file: file, line: line)
            return
        }
        
        let route = sut.route(forTrip: index)
        guard let coordinate = validCoordinate ? route.first : route.last
            else {
                XCTAssertFalse(toSucceed, "Expected failure because test has no validCoordinate", file: file, line: line)
                return
        }
        XCTAssertEqual(toSucceed, sut.isStart(coordinate: coordinate), file: file, line: line)
    }
}
