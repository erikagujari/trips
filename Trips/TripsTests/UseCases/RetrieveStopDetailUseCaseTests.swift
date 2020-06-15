//
//  RetrieveStopDetailUseCaseTests.swift
//  TripsTests
//
//  Created by Erik Agujari on 15/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
import Trips
import Combine

final class RetrieveStopDetailUseCaseTests: XCTestCase {
    func test_fetchStopDetailWithInvalidIdDeliversTripServiceErrorWithErrorRepository() {
        let sut = makeSUT(repository: ErrorRepository())
        expect(sut: sut, withId: -111, toEndIn: .failure(.serviceError))
    }
    
    func test_fetchStopDetailWithValidIdDeliversTripServiceErrorWithErrorRepository() {
        let sut = makeSUT(repository: ErrorRepository())
        expect(sut: sut, withId: 1, toEndIn: .failure(.serviceError))
    }
    
    func test_fetchStopDetailWithInvalidIdDeliversTripParsingErrorWithInvalidRepository() {
        let sut = makeSUT(repository: InvalidRepository())
        expect(sut: sut, withId: -111, toEndIn: .failure(.parsingError))
    }
    
    func test_fetchStopDetailWithValidIdDeliversTripParsingErrorWithInvalidRepository() {
        let sut = makeSUT(repository: InvalidRepository())
        expect(sut: sut, withId: 1, toEndIn: .failure(.parsingError))
    }
    
    func test_fetchStopDetailWithInValidIdDeliversTripParsingErrorWithValidRepository() {
        let sut = makeSUT(repository: ValidRepository())
        expect(sut: sut, withId: -2, toEndIn: .failure(.parsingError))
    }
    
    func test_fetchStopDetailWithValidIdDeliversSuccessWithValidRepository() {
        let sut = makeSUT(repository: ValidRepository())
        expect(sut: sut, withId: 2, toEndIn: .finished)
    }
}

extension RetrieveStopDetailUseCaseTests {
    private func makeSUT(repository: TripRepositoryProtocol) -> RetrieveStopDetailUseCaseProtocol {
        let useCase = RetrieveStopDetailUseCase(dependencies: StubStopDetailUseCaseDependencies(repository: repository))
        trackForMemoryLeaks(instance: useCase)
        return useCase
    }
    
    private func expect(sut: RetrieveStopDetailUseCaseProtocol, withId id: Int, toEndIn expectedResult: Subscribers.Completion<TripError>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for stop detail")
        var cancellable = Set<AnyCancellable>()
        
        sut.fetchStopDetail(id: id)
            .sink(receiveCompletion: { receivedresult in
                XCTAssertEqual(receivedresult, expectedResult, file: file, line: line)
                exp.fulfill()
            }, receiveValue: { value in
                
            })
        .store(in: &cancellable)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    private struct StubStopDetailUseCaseDependencies: RetrieveStopDetailUseCaseDependenciesProtocol {
        var repository: TripRepositoryProtocol
        
        init(repository: TripRepositoryProtocol) {
            self.repository = repository
        }
    }
    
    private struct ErrorRepository: TripRepositoryProtocol {
        func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
            return Future { promise in
                promise(.failure(TripError.serviceError))
            }.eraseToAnyPublisher()
        }
        
        func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
            return Future { promise in
                promise(.failure(TripError.serviceError))
            }.eraseToAnyPublisher()
        }
    }
    
    private struct InvalidRepository: TripRepositoryProtocol {
        func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
            return Future { promise in
                promise(.failure(TripError.serviceError))
            }.eraseToAnyPublisher()
        }
        
        func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
            return Future { promise in
                let stopDetail = StopDetailResponse(userName: nil,
                                                    point: nil,
                                                    price: nil,
                                                    stopTime: nil,
                                                    paid: nil,
                                                    address: nil,
                                                    tripId: id)
                promise(.success(stopDetail))
            }.eraseToAnyPublisher()
        }
    }
    
    private struct ValidRepository: TripRepositoryProtocol {
        func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
            return Future { promise in
                promise(.failure(TripError.serviceError))
            }.eraseToAnyPublisher()
        }
        
        func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
            return Future { promise in
                if id < 0 {
                    let stopDetail = StopDetailResponse(userName: nil,
                                                        point: nil,
                                                        price: nil,
                                                        stopTime: nil,
                                                        paid: nil,
                                                        address: nil,
                                                        tripId: id)
                    promise(.success(stopDetail))
                } else {
                    let stopDetail = StopDetailResponse(userName: "Bob",
                                                        point: nil,
                                                        price: nil,
                                                        stopTime: nil,
                                                        paid: nil,
                                                        address: "FakeStreet 2nd Floor",
                                                        tripId: id)
                    promise(.success(stopDetail))
                }
            }.eraseToAnyPublisher()
        }
    }
}
