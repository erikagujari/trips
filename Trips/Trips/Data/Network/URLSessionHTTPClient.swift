//
//  URLSessionHTTPClient.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import Foundation
import Combine

public class URLSessionHTTPClient: CombineHTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetch<T: Decodable>(_ request: Service, responseType: T.Type) -> AnyPublisher<T, TripError> {
        return session.dataTaskPublisher(for: request.urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse
                    else {
                        throw TripError.serviceError
                }
                
                guard (200...299).contains(httpResponse.statusCode)
                    else {
                        throw TripError.serviceError
                }
                
                if let string = String(data: data, encoding: .utf8){
                    print("JSON Response:\n\(string)")
                }
                return data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError { error -> TripError in
            guard let error = error as? TripError
                else {
                    return TripError.serviceError
            }
            return error
        }
        .eraseToAnyPublisher()
    }
}

