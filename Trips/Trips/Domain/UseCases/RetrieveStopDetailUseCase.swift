//
//  RetrieveStopDetailUseCase.swift
//  Trips
//
//  Created by AGUJARI Erik on 06/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import Combine

protocol RetrieveStopDetailUseCaseProtocol {
    func fetchStopDetail(id: Int) -> AnyPublisher<StopDetail, TripError>
}

protocol RetrieveStopDetailUseCaseDependenciesProtocol {
    var repository: TripRepositoryProtocol { get }
    var mapper: StopDetailResponseMapper { get }
}

struct RetrieveStopDetailUseCaseDependencies: RetrieveStopDetailUseCaseDependenciesProtocol {
    var repository: TripRepositoryProtocol = TripRepository()
    var mapper: StopDetailResponseMapper = StopDetailResponseMapper()
}

struct RetrieveStopDetailUseCase: RetrieveStopDetailUseCaseProtocol {
    private let dependencies: RetrieveStopDetailUseCaseDependenciesProtocol

    init(dependencies: RetrieveStopDetailUseCaseDependenciesProtocol = RetrieveStopDetailUseCaseDependencies()) {
        self.dependencies = dependencies
    }
    
    func fetchStopDetail(id: Int) -> AnyPublisher<StopDetail, TripError> {
        return dependencies.repository.retrieveStop(id: id)
            .map { self.dependencies.mapper.map(response: $0) }
            .eraseToAnyPublisher()
    }
}
