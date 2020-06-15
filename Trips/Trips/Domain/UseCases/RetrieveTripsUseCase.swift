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
}

struct RetrieveTripsUseCaseDependencies: RetrieveTripsUseCaseDependenciesProtocol {
    var repository: TripRepositoryProtocol = TripRepository()
}

struct RetrieveTripsUseCase: RetrieveTripsUseCaseProtocol {
    private let dependencies: RetrieveTripsUseCaseDependenciesProtocol

    init(dependencies: RetrieveTripsUseCaseDependenciesProtocol = RetrieveTripsUseCaseDependencies()) {
        self.dependencies = dependencies
    }

    var trips: AnyPublisher<[Trip], TripError> {
        return dependencies.repository.retrieveTrips()
            .flatMapNilEntityToError(mapperType: TripArrayResponseMapper.self)
    }
}
