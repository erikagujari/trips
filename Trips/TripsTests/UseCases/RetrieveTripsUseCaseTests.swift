//
//  RetrieveTripsUseCaseTests.swift
//  TripsTests
//
//  Created by Erik Agujari on 15/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
import Trips
import Combine

final class RetrieveTripsUseCaseTests: XCTestCase {
    func test_getTripsDeliversTripServiceErrorWithErrorRepository() {
        let sut = makeSUT(repository: TripErrorRepository())
        expect(sut: sut, toEndIn: .failure(.serviceError))
    }
    
    func test_getTripsDeliversTripParsingErrorWithEmptyRepository() {
        let sut = makeSUT(repository: TripEmptyRepository())
        expect(sut: sut, toEndIn: .failure(.parsingError))
    }
    
    func test_getTripsDeliversTripParsingErrorWithInvalidRepository() {
        let sut = makeSUT(repository: TripInvalidRepository())
        expect(sut: sut, toEndIn: .failure(.parsingError))
    }
    
    func test_getTripsDeliversTripSuccessWithValidRepository() {
        let sut = makeSUT(repository: TripValidRepository())
        expect(sut: sut, toEndIn: .finished)
    }
    
    func test_getTripsDeliversTripSuccessWithCompleteRepository() {
        let sut = makeSUT(repository: TripCompleteRepository())
        expect(sut: sut, toEndIn: .finished)
    }
}

extension RetrieveTripsUseCaseTests {
    private func makeSUT(repository: TripRepositoryProtocol) -> RetrieveTripsUseCaseProtocol {
        let useCase = RetrieveTripsUseCase(dependencies: StubTripUseCaseDependencies(repository: repository))
        trackForMemoryLeaks(instance: useCase)
        return useCase
    }
    
    private func expect(sut: RetrieveTripsUseCaseProtocol, toEndIn expectedResult: Subscribers.Completion<TripError>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for stop detail")
        var cancellable = Set<AnyCancellable>()
        
        sut.trips
            .sink(receiveCompletion: { receivedresult in
                XCTAssertEqual(receivedresult, expectedResult, file: file, line: line)
                exp.fulfill()
            }, receiveValue: { value in
                
            })
            .store(in: &cancellable)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    private struct StubTripUseCaseDependencies: RetrieveTripsUseCaseDependenciesProtocol {
        var repository: TripRepositoryProtocol
        
        init(repository: TripRepositoryProtocol) {
            self.repository = repository
        }
    }
}
