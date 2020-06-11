//
//  CoreDataManagerTests.swift
//  TripsTests
//
//  Created by Erik Agujari on 10/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
import Trips
import Combine

final class CoreDataManagerTests: XCTestCase {
    func test_resetSucceeds() {
        let sut = makeSUT()
        let exp = expectation(description: "Waiting for form count")
        var cancellable = Set<AnyCancellable>()
        
        reset(sut: sut)
            .flatMap { _ in sut.storedFormsCount }
            .sink(receiveCompletion: { event in
                switch event {
                case .finished: break
                case .failure(let error):
                    XCTFail("Expected success, but got \(error) instead")
                }
                exp.fulfill()
            }, receiveValue: { count in
                XCTAssertEqual(0, count)
            })
            .store(in: &cancellable)
        wait(for: [exp], timeout: 0.2)
    }
    
    func test_resetFailsWithPersistenceError_whenHasNoContext() {
        let sut = makeSUT(with: EmptyViewContext())
        let exp = expectation(description: "Waiting for form count")
        var cancellable = Set<AnyCancellable>()
        
        reset(sut: sut)
            .flatMap { _ in sut.storedFormsCount }
            .sink(receiveCompletion: { event in
                switch event {
                case .finished:
                    XCTFail("Expected failure, but got success instead")
                case .failure(let error):
                    XCTAssertEqual(error, .persistenceError, "Expected persistence error, but got \(error) instead")
                }
                exp.fulfill()
            }, receiveValue: { count in
                XCTAssertEqual(0, count)
            })
            .store(in: &cancellable)
        wait(for: [exp], timeout: 0.2)
    }
    
    func test_resetFailsWithPersistenceError_whenHasNoAppDelegateContextReference() {
        let sut = makeSUT(with: StubViewContext())
        let exp = expectation(description: "Waiting for form count")
        var cancellable = Set<AnyCancellable>()
        
        sut.reset()
            .sink(receiveCompletion: { event in
                switch event {
                case .finished:
                    XCTFail("Expected failure, but got success instead")
                case .failure(let error):
                    XCTAssertEqual(error, .persistenceError, "Expected persistence error, but got \(error) instead")
                }
                exp.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellable)
        wait(for: [exp], timeout: 0.2)
    }
}

extension CoreDataManagerTests {
    private func makeSUT(with context: ViewContextProcol? = nil) -> SaverProtocol {
        guard let context = context
            else {
                return CoreDataManager()
        }
        return CoreDataManager(viewContext: context)
    }
    
    private static func storeStubAndReturnCount(sut: SaverProtocol) -> AnyPublisher<Int, TripError> {
        return sut.save(form: FormData(name: "",
                                       surname: "",
                                       email: "",
                                       phone: "",
                                       date: "",
                                       description: ""))
            .flatMap {
                return sut.storedFormsCount.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    private func ensureStoreFormsAreNotZero(sut: SaverProtocol, file: StaticString = #file, line: UInt = #line) -> AnyPublisher<Int, TripError> {
        return sut.storedFormsCount
            .flatMap { count -> AnyPublisher<Int, TripError> in
                guard count == 0 else {
                    return Just(count)
                        .setFailureType(to: TripError.self)
                        .eraseToAnyPublisher()
                }
                return CoreDataManagerTests.storeStubAndReturnCount(sut: sut)
        }.eraseToAnyPublisher()
    }
    
    private func reset(sut: SaverProtocol) -> AnyPublisher<Void, TripError> {
        return ensureStoreFormsAreNotZero(sut: sut)
            .flatMap { _ in
                sut.reset()
        }.eraseToAnyPublisher()
    }
}
