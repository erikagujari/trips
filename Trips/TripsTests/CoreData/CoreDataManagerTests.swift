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
    func test_storedFormsCountReturnsError_whenHasNoContext() {
        let sut = makeSUT(with: EmptyViewContext())
        expectStoredFormsCount(sut: sut, toEndWith: .failure(.persistenceError))
    }
    
    func test_storedFormsCountReturnsError_whenContextIsNotAsExpected() {
        let sut = makeSUT(with: StubViewContext())
        expectStoredFormsCount(sut: sut, toEndWith: .failure(.persistenceError))
    }
    
    func test_storedFormsCountSucceeds_whenHasDefaultContext() {
        let sut = makeSUT()
        expectStoredFormsCount(sut: sut, toEndWith: .finished)
    }
    
    func test_resetFailsWithPersistenceError_whenHasNoContext() {
        let sut = makeSUT(with: EmptyViewContext())
        expectResetFor(sut: sut, toEndWith: .failure(.persistenceError))
    }
    
    func test_resetFailsWithPersistenceError_whenContextIsNotAsExpected() {
        let sut = makeSUT(with: StubViewContext())
        expectResetFor(sut: sut, toEndWith: .failure(.persistenceError))
    }
    
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
}

//MARK: - Helpers
extension CoreDataManagerTests {
    private func makeSUT(with context: ViewContextProcol? = nil) -> SaverProtocol {
        guard let context = context
            else {
                return CoreDataManager()
        }
        return CoreDataManager(viewContext: context)
    }
    
    private func expectResetFor(sut: SaverProtocol, toEndWith result: Subscribers.Completion<TripError>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for form reset")
        var cancellable = Set<AnyCancellable>()
        
        sut.reset()
            .sink(receiveCompletion: { event in
                XCTAssertEqual(result, event, "Expected \(result), but got \(event)", file: file, line: line)
                exp.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellable)
        wait(for: [exp], timeout: 0.2)
    }
    
    private func expectStoredFormsCount(sut: SaverProtocol, toEndWith result: Subscribers.Completion<TripError>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for form count")
        var cancellable = Set<AnyCancellable>()
        
        sut.storedFormsCount
            .sink(receiveCompletion: { event in
                XCTAssertEqual(event, result, file: file, line: line)
                exp.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellable)
        wait(for: [exp], timeout: 0.2)
    }
}

//MARK: Reset flow
extension CoreDataManagerTests {
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
