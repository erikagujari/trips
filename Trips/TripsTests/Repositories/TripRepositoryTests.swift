//
//  TripRepositoryTests.swift
//  TripsTests
//
//  Created by Erik Agujari on 14/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
import Trips
import Combine

final class TripRepositoryTests: XCTestCase {
    func test_retrieveTripsEndsInServiceError_withStubTripLoader() {
        let sut = makeSUT(with: StubTripLoader())
        expectRetrieveTrips(for: sut, toEndWith: .failure(.serviceError))
    }
    
    func test_retrieveTripsEndsInSuccess_withDefaultTripLoader() {
        let sut = makeSUT(with: DefaultTripLoader())
        expectRetrieveTrips(for: sut, toEndWith: .finished)
    }
    
    func test_retrieveStopsForInvalidIdEndsInServiceError_withStubTripLoader() {
        let sut = makeSUT(with: StubTripLoader())
        expectRetrieveStops(for: sut, andId: -100, toEndWith: .failure(.serviceError))
    }
    
    func test_retrieveStopsForValidIdEndsInServiceError_withStubTripLoader() {
        let sut = makeSUT(with: StubTripLoader())
        expectRetrieveStops(for: sut, andId: 1, toEndWith: .failure(.serviceError))
    }
    
    func test_retrieveStopsForInValidIdEndsInServiceError_withDefaultTripLoader() {
        let sut = makeSUT(with: DefaultTripLoader())
        expectRetrieveStops(for: sut, andId: -100, toEndWith: .failure(.serviceError))
    }
    
    func test_retrieveStopsForInValidIdEndsInSuccess_withDefaultTripLoader() {
        let sut = makeSUT(with: DefaultTripLoader())
        expectRetrieveStops(for: sut, andId: 1, toEndWith: .finished)
    }
}

extension TripRepositoryTests {
    private func makeSUT(with loader: TripLoader) -> TripRepositoryProtocol {
        let dependencies: TripRepositoryDependenciesProtocol = TripRepositoryDependencies(loader: loader)
        let repository = TripRepository(dependencies: dependencies)
        trackForMemoryLeaks(instance: repository)
        return repository
    }
    
    private func expectRetrieveTrips(for sut: TripRepositoryProtocol, toEndWith expectedResult: Subscribers.Completion<TripError>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for trips")
        var cancellable = Set<AnyCancellable>()
        
        sut.retrieveTrips()
            .sink(receiveCompletion: { receivedResult in
                XCTAssertEqual(receivedResult, expectedResult, file: file, line: line)
                exp.fulfill()
            }, receiveValue: { _ in })
        .store(in: &cancellable)
        
        wait(for: [exp], timeout: 10.0)
    }
    
    private func expectRetrieveStops(for sut: TripRepositoryProtocol, andId id: Int, toEndWith expectedResult: Subscribers.Completion<TripError>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for trips")
        var cancellable = Set<AnyCancellable>()
        
        sut.retrieveStop(id: id)
            .sink(receiveCompletion: { receivedResult in
                XCTAssertEqual(receivedResult, expectedResult, file: file, line: line)
                exp.fulfill()
            }, receiveValue: { _ in })
        .store(in: &cancellable)
        
        wait(for: [exp], timeout: 10.0)
    }
    
    private struct StubRepositoryDependencies: TripRepositoryDependenciesProtocol {
        var client: CombineHTTPClient = URLSessionHTTPClient()
        var loader: TripLoader = StubTripLoader()
    }
    
    private struct StubTripLoader: TripLoader {
        private struct StubTripService: Service {
            var baseURL: String = ""
            var path: String = ""
            var parameters: [String : Any]? = nil
            var method: ServiceMethod = .get
        }
        
        private struct StubStopService: Service {
            var baseURL: String = ""
            var path: String = ""
            var parameters: [String : Any]? = nil
            var method: ServiceMethod = .get
        }
        
        var tripsService: Service {
            return StubTripService()
        }
        
        func stopService(id: Int) -> Service {
            return StubStopService()
        }
    }
}
