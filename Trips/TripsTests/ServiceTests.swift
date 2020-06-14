//
//  ServiceTests.swift
//  TripsTests
//
//  Created by Erik Agujari on 14/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
import Trips

final class ServiceTests: XCTestCase {
    func test_getServiceWithParametersHasNotHttpBody() {
        let service = makeSUT(method: .get, parameters: anyParameters())
        expect(sut: service, toHaveHttpBody: false)
    }
    
    func test_getServiceWithoutParametersHasNotHttpBody() {
        let service = makeSUT(method: .get, parameters: nil)
        expect(sut: service, toHaveHttpBody: false)
    }
    
    func test_postServiceWithoutParametersHasNotHttpBody() {
        let service = makeSUT(method: .post, parameters: nil)
        expect(sut: service, toHaveHttpBody: false)
    }
    
    func test_postServiceWithParametersHasHttpBody() {
        let service = makeSUT(method: .post, parameters: anyParameters())
        expect(sut: service, toHaveHttpBody: true)
    }
    
    func test_getServiceWithoutParametersHasNotUrlQuery() {
        let service = makeSUT(method: .get, parameters: nil)
        expect(sut: service, toHaveUrlQuery: false)
    }
    
    func test_getServiceWithParametersHasUrlQuery() {
        let service = makeSUT(method: .get, parameters: anyParameters())
        expect(sut: service, toHaveUrlQuery: true)
    }
    
    func test_postServiceWithoutParametersHasNotUrlQuery() {
        let service = makeSUT(method: .post, parameters: nil)
        expect(sut: service, toHaveUrlQuery: false)
    }
    
    func test_postServiceWithParametersHasNotUrlQuery() {
        let service = makeSUT(method: .post, parameters: anyParameters())
        expect(sut: service, toHaveUrlQuery: false)
    }
}

extension ServiceTests {
    private class StubService: Service {
        var baseURL: String = ""
        var path: String = ""
        var parameters: [String : Any]?
        var method: ServiceMethod
        
        init(method: ServiceMethod = .get, parameters: [String: Any]?) {
            self.parameters = parameters
            self.method = method
        }
    }
    
    private func makeSUT(method: ServiceMethod, parameters: [String: Any]? = nil) -> Service {
        let service = StubService(method: method, parameters: parameters)
        trackForMemoryLeaks(instance: service)
        return service
    }
    
    private func expect(sut: Service, toHaveHttpBody assertion: Bool, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(assertion, sut.urlRequest.httpBody != nil, file: file, line: line)
    }
    
    private func expect(sut: Service, toHaveUrlQuery assertion: Bool, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(assertion, sut.urlRequest.url?.query != nil, file: file, line: line)
    }
    
    private func anyParameters() -> [String: Any] {
        return ["test": "value"]
    }
}

