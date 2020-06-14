//
//  TripRepository.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import Combine

protocol TripRepositoryDependenciesProtocol {
    var client: CombineHTTPClient { get }
    var loader: TripLoader { get }
}

struct TripRepositoryDependencies: TripRepositoryDependenciesProtocol {
    var loader: TripLoader = DefaultTripLoader()
    var client: CombineHTTPClient = URLSessionHTTPClient()
}

public protocol TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError>
    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError>
}

struct TripRepository: TripRepositoryProtocol {
    let dependencies: TripRepositoryDependenciesProtocol

    init(dependencies: TripRepositoryDependenciesProtocol = TripRepositoryDependencies()) {
        self.dependencies = dependencies
    }

    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        let service = dependencies.loader.tripsService
        return dependencies.client.fetch(service, responseType: [TripResponse].self)
    }

    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
        let service = dependencies.loader.stopService(id: id)
        return dependencies.client.fetch(service, responseType: StopDetailResponse.self)
    }
}

