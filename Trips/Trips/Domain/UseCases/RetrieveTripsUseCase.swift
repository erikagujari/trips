//
//  RetrieveTripsUseCase.swift
//  Trips
//
//  Created by AGUJARI Erik on 03/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

public protocol RetrieveTripsUseCaseProtocol {
    var trips: AnyPublisher<[Trip], TripError> { get }
}

public protocol RetrieveTripsUseCaseDependenciesProtocol {
    var repository: TripRepositoryProtocol { get }
}

public struct RetrieveTripsUseCaseDependencies: RetrieveTripsUseCaseDependenciesProtocol {
    public var repository: TripRepositoryProtocol
    
    public init(repository: TripRepositoryProtocol = TripRepository()) {
        self.repository = repository
    }
}

public class RetrieveTripsUseCase: RetrieveTripsUseCaseProtocol {
    private let dependencies: RetrieveTripsUseCaseDependenciesProtocol

    public init(dependencies: RetrieveTripsUseCaseDependenciesProtocol = RetrieveTripsUseCaseDependencies()) {
        self.dependencies = dependencies
    }

    public var trips: AnyPublisher<[Trip], TripError> {
        return dependencies.repository.retrieveTrips()
            .flatMapNilEntityToError(mapperType: TripArrayResponseMapper.self)
    }
}
