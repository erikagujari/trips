//
//  TripRepository.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import Combine

public protocol TripRepositoryDependenciesProtocol {
    var client: CombineHTTPClient { get }
    var loader: TripLoader { get }
}

public struct TripRepositoryDependencies: TripRepositoryDependenciesProtocol {
    public var loader: TripLoader
    public var client: CombineHTTPClient = URLSessionHTTPClient()
    
    public init(loader: TripLoader = DefaultTripLoader()) {
        self.loader = loader
    }
}

public protocol TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError>
    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError>
}

public class TripRepository: TripRepositoryProtocol {
    private let dependencies: TripRepositoryDependenciesProtocol
    
    public init(dependencies: TripRepositoryDependenciesProtocol = TripRepositoryDependencies()) {
        self.dependencies = dependencies
    }
    
    public func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        let service = dependencies.loader.tripsService
        return dependencies.client.fetch(service, responseType: [TripResponse].self)
    }
    
    public func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
        let service = dependencies.loader.stopService(id: id)
        return dependencies.client.fetch(service, responseType: StopDetailResponse.self)
    }
}

