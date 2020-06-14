//
//  TripRepository.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import Combine

protocol TripRepositoryDependenciesProtocol {
    var service: CombineHTTPClient { get }
}

struct TripRepositoryDependencies: TripRepositoryDependenciesProtocol {
    var service: CombineHTTPClient = URLSessionHTTPClient()
}

protocol TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError>
    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError>
}

struct TripRepository: TripRepositoryProtocol {
    let dependencies: TripRepositoryDependenciesProtocol

    init(dependencies: TripRepositoryDependenciesProtocol = TripRepositoryDependencies()) {
        self.dependencies = dependencies
    }

    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        dependencies.service.fetch(TripService.trips,
                                   responseType: [TripResponse].self)
    }

    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
        dependencies.service.fetch(TripService.stops(id),
                                   responseType: StopDetailResponse.self)
    }
}

