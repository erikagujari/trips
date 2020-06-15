//
//  RetrieveStopDetailUseCase.swift
//  Trips
//
//  Created by AGUJARI Erik on 06/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import Combine

public protocol RetrieveStopDetailUseCaseProtocol {
    func fetchStopDetail(id: Int) -> AnyPublisher<StopDetail, TripError>
}

public protocol RetrieveStopDetailUseCaseDependenciesProtocol {
    var repository: TripRepositoryProtocol { get }
}

public struct RetrieveStopDetailUseCaseDependencies: RetrieveStopDetailUseCaseDependenciesProtocol {
    public var repository: TripRepositoryProtocol
    
    public init(repository: TripRepositoryProtocol = TripRepository()) {
        self.repository = repository
    }
}

public class RetrieveStopDetailUseCase: RetrieveStopDetailUseCaseProtocol {
    private let dependencies: RetrieveStopDetailUseCaseDependenciesProtocol

    public init(dependencies: RetrieveStopDetailUseCaseDependenciesProtocol = RetrieveStopDetailUseCaseDependencies()) {
        self.dependencies = dependencies
    }
    
    public func fetchStopDetail(id: Int) -> AnyPublisher<StopDetail, TripError> {
        return dependencies.repository.retrieveStop(id: id)
            .flatMapNilEntityToError(mapperType: StopDetailResponseMapper.self, responseType: StopDetailResponse.self, resultType: StopDetail.self)
    }
}
