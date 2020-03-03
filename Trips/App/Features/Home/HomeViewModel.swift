//
//  HomeViewModel.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine

protocol HomeViewModelProtocol {
    func retrieveTrips()
}

protocol HomeViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> { get set }
    var tripsUseCase: RetrieveTripsUseCaseProtocol { get }
}

struct HomeViewModelDependencies: HomeViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    var tripsUseCase: RetrieveTripsUseCaseProtocol = RetrieveTripsUseCase()
}

final class HomeViewModel {
    var dependencies: HomeViewModelDependenciesProtocol

    init(dependencies: HomeViewModelDependenciesProtocol = HomeViewModelDependencies()) {
        self.dependencies = dependencies
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func retrieveTrips() {
        //TODO: show and hide spinner
        dependencies.tripsUseCase.trips
        .sink(receiveCompletion: { event in
            switch event {
            case .finished:
                print("update ui")
            case .failure(let error):
                print("show error")
            }
        }) { trips in
            print(trips)
        }
        .store(in: &dependencies.cancellable)
    }
}
