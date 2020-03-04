//
//  HomeViewModel.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

class HomePublishedProperties {
    @Published var cellModels: [HomeCellModel] = []
    @Published var isFetching: Bool = false
    @Published var errorMessage: String = ""
}

protocol HomeViewModelProtocol: HomePublishedProperties {
    func retrieveTrips()
}

protocol HomeViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> { get set }
    var tripsUseCase: RetrieveTripsUseCaseProtocol { get }
    var mapper: HomeCellMapper { get }
}

struct HomeViewModelDependencies: HomeViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    var tripsUseCase: RetrieveTripsUseCaseProtocol = RetrieveTripsUseCase()
    var mapper: HomeCellMapper = HomeCellMapper()
}

final class HomeViewModel: HomePublishedProperties {
    var dependencies: HomeViewModelDependenciesProtocol

    init(dependencies: HomeViewModelDependenciesProtocol = HomeViewModelDependencies()) {
        self.dependencies = dependencies
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func retrieveTrips() {
        isFetching = true
        dependencies.tripsUseCase.trips
        .sink(receiveCompletion: { [weak self] event in
            switch event {
            case .finished: break
            case .failure(let error):
                self?.errorMessage = error.message
            }
            self?.isFetching = false
        }) { [weak self] trips in
            self?.cellModels = self?.dependencies.mapper.mapArray(domainArray: trips) ?? []
        }
        .store(in: &dependencies.cancellable)
    }
}
