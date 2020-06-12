//
//  URLSessionHTTPClientTests.swift
//  TripsTests
//
//  Created by Erik Agujari on 11/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
import Trips
import Combine

class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_performsRequestWithURL() {
        let url = anyURL()
        let service = StubGetService()
        var cancellable = Set<AnyCancellable>()
        let exp = expectation(description: "Wait for request")
        URLProtocolStub.observeRequests(observer: { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, service.method.rawValue)
            exp.fulfill()
        })
        makeSUT().fetch(service, responseType: StubEntity.self)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in })
            .store(in: &cancellable)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromUrl_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
        XCTAssertEqual(receivedError as? TripError, TripError.serviceError)
    }
}

extension URLSessionHTTPClientTests {
    private class StubGetService: Service {
        var baseURL: String = "http://any-url.com"
        var path: String = ""
        var parameters: [String : Any]? = nil
        var method: ServiceMethod = .get
    }
    
    private struct StubEntity: Decodable {}
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CombineHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return sut
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0, userInfo: nil)
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch result {
        case .failure(let error):
            return error
        default:
            XCTFail("Expected failure, got result \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Subscribers.Completion<TripError> {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        var cancellable = Set<AnyCancellable>()
        var receivedResult: Subscribers.Completion<TripError>!
        
        sut.fetch(StubGetService(), responseType: StubEntity.self)
            .sink(receiveCompletion: { result in
                receivedResult = result
                exp.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellable)
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data,
                        response: response,
                        error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {
            
        }
    }
}
