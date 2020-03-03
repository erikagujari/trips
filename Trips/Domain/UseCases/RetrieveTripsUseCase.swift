//
//  RetrieveTripsUseCase.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

protocol RetrieveTripsUseCaseProtocol {
    var trips: AnyPublisher<[Trip], TripError> { get }
}

protocol RetrieveTripsUseCaseDependenciesProtocol {
    var repository: TripRepositoryProtocol { get }
    var mapper: TripResponseMapper { get }
}

struct RetrieveTripsUseCaseDependencies: RetrieveTripsUseCaseDependenciesProtocol {
    var repository: TripRepositoryProtocol = TripRepository()
    var mapper: TripResponseMapper = TripResponseMapper()
}

struct RetrieveTripsUseCase: RetrieveTripsUseCaseProtocol {
    private let dependencies: RetrieveTripsUseCaseDependenciesProtocol

    init(dependencies: RetrieveTripsUseCaseDependenciesProtocol = RetrieveTripsUseCaseDependencies()) {
        self.dependencies = dependencies
    }

    var trips: AnyPublisher<[Trip], TripError> {
        return dependencies.repository.retrieveTrips()
            .map { self.dependencies.mapper.mapArray(response: $0) }
            .eraseToAnyPublisher()
    }
}
