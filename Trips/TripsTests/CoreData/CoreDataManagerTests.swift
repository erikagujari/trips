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
    func test_storedFormsCountFailsWithPersistenceError_whenHasNoContext() {
        let sut = makeSUT(with: EmptyViewContext())
        expectStoredFormsCount(sut: sut, toEndWith: .failure(.persistenceError))
    }
    
    func test_storedFormsCountFailsWithPersistenceError_whenContextIsNotAsExpected() {
        let sut = makeSUT(with: StubViewContext())
        expectStoredFormsCount(sut: sut, toEndWith: .failure(.persistenceError))
    }
    
    func test_storedFormsCountSucceeds_whenHasDefaultContext() {
        let sut = makeSUT()
        expectStoredFormsCount(sut: sut, toEndWith: .finished)
    }
    
    func test_saveFormFailsWithPersistenceError_whenHasNoContext() {
        let sut = makeSUT(with: EmptyViewContext())
        expectSave(sut: sut, form: anyFormData(), toEndWith: .failure(.persistenceError))
    }
    
    func test_saveFormFailsWithPersistenceError_whenContextIsNotAsExpected() {
        let sut = makeSUT(with: StubViewContext())
        expectSave(sut: sut, form: anyFormData(), toEndWith: .failure(.persistenceError))
    }
    
    func test_saveFormSucceeds_whenHasDefaultContext() {
        let sut = makeSUT()
        expectStoredFormsCount(sut: sut, toEndWith: .finished, completion: { [weak self] beforeSavingCount in
            guard let self = self else {
                XCTFail("Error on self instance being nil")
                return
            }
            self.expectSave(sut: sut, form: self.anyFormData(), toEndWith: .finished, completion: { _ in
                self.expectStoredFormsCount(sut: sut, toEndWith: .finished, completion: { afterSavingCount in
                    XCTAssertNotEqual(beforeSavingCount, afterSavingCount)
                })
            })
        })
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
    private func anyFormData() -> FormData {
        return FormData(name: "Bob",
                        surname: "Dylan",
                        email: "bobdylan@gmail.com",
                        phone: "611333444",
                        date: "2020-10-06",
                        description: "Improve this if you can")
    }
    
    private func makeSUT(with context: ViewContextProcol? = nil) -> SaverProtocol {
        guard let context = context
            else {
                let coreDataManager = CoreDataManager()
                trackForMemoryLeaks(instance: coreDataManager)
                return coreDataManager
        }
        let coreDataManager = CoreDataManager(viewContext: context)
        trackForMemoryLeaks(instance: coreDataManager)
        return coreDataManager
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
    
    private func expectStoredFormsCount(sut: SaverProtocol, toEndWith result: Subscribers.Completion<TripError>, completion: ((Int) -> Void)? = nil, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for form count")
        var cancellable = Set<AnyCancellable>()
        
        sut.storedFormsCount
            .sink(receiveCompletion: { event in
                XCTAssertEqual(event, result, file: file, line: line)
                exp.fulfill()
            }, receiveValue: { count in
                completion?(count)
            })
            .store(in: &cancellable)
        wait(for: [exp], timeout: 0.2)
    }
    
    private func expectSave(sut: SaverProtocol, form: FormData, toEndWith result: Subscribers.Completion<TripError>, completion: ((Subscribers.Completion<TripError>) -> Void)? = nil, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for save form")
        var cancellable = Set<AnyCancellable>()
        
        sut.save(form: form)
            .sink(receiveCompletion: { event in
                XCTAssertEqual(event, result, file: file, line: line)
                completion?(event)
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
