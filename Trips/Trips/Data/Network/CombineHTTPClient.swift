//
//  CombineHTTPClient.swift
//  Trips
//
//  Created by Erik Agujari on 11/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

protocol CombineHTTPClient {
    func fetch<T: Decodable>(_ request: Service, responseType: T.Type) -> AnyPublisher<T, TripError>
}
