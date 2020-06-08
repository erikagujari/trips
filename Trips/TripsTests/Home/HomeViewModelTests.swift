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
    
    private func expect(sut: HomeViewModelProtocol, withIndex index: Int, for poiType: POIType, toBeEmpty: Bool) {
        sut.retrieveTrips()
        let route = poiType == .route ? sut.route(forTrip: index) : sut.stops(forTrip: index)
        
        XCTAssertEqual(route.isEmpty, toBeEmpty)
    }
}
