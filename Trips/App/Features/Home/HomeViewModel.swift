//
//  HomeViewModel.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine
import CoreLocation

class HomePublishedProperties {
    @Published var cellModels: [HomeCellModel] = []
    @Published var isFetching: Bool = false
    @Published var error: ErrorAction? = nil
    @Published var stopDetail: StopAnnotationModel?
}

protocol HomeViewModelProtocol: HomePublishedProperties {
    func retrieveTrips()
    func route(forTrip index: Int) -> [CLLocationCoordinate2D]
    func stops(forTrip index: Int) -> [CLLocationCoordinate2D]
    func retrieveStopDetail(for coordinate: CLLocationCoordinate2D)
    func isStart(coordinate: CLLocationCoordinate2D) -> Bool
    func isEnd(coordinate: CLLocationCoordinate2D) -> Bool
}

protocol HomeViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> { get set }
    var tripsUseCase: RetrieveTripsUseCaseProtocol { get }
    var stopUseCase: RetrieveStopDetailUseCaseProtocol { get }
    var cellMapper: HomeCellMapper { get }
    var annotationMapper: StopAnnotationMapper { get }
}

struct HomeViewModelDependencies: HomeViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    var tripsUseCase: RetrieveTripsUseCaseProtocol = RetrieveTripsUseCase()
    var stopUseCase: RetrieveStopDetailUseCaseProtocol = RetrieveStopDetailUseCase()
    var cellMapper: HomeCellMapper = HomeCellMapper()
    var annotationMapper: StopAnnotationMapper = StopAnnotationMapper()
}

final class HomeViewModel: HomePublishedProperties {
    private var trips: [Trip] = []
    private var selectedTrip: Int?
    private var dependencies: HomeViewModelDependenciesProtocol

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
            case .finished:
                self?.isFetching = false
            case .failure(let error):
                self?.error = ErrorAction(message: error.message, action: {
                    self?.retrieveTrips()
                })
                self?.isFetching = false
            }
        }) { [weak self] trips in
            self?.trips = trips
            self?.cellModels = self?.dependencies.cellMapper.mapArray(domainArray: trips) ?? []
            self?.isFetching = false
        }
        .store(in: &dependencies.cancellable)
    }

    func route(forTrip index: Int) -> [CLLocationCoordinate2D] {
        guard trips.indices.contains(index)
            else {
                return []
        }
        selectedTrip = index
        return trips[index].route
    }

    func stops(forTrip index: Int) -> [CLLocationCoordinate2D] {
        guard trips.indices.contains(index)
            else {
                return []
        }

        return trips[index].stops.map { $0.point.coordinate }
    }

    func retrieveStopDetail(for coordinate: CLLocationCoordinate2D) {
        isFetching = true
        guard let selectedTrip = selectedTrip,
            trips.indices.contains(selectedTrip),
            let id = trips[selectedTrip].stops.first(where: { $0.point.coordinate == coordinate })?.id
            else {
                isFetching = false
                return
        }
        dependencies.stopUseCase.fetchStopDetail(id: id)
            .sink(receiveCompletion: { [weak self] event in
                switch event {
                case .finished: break
                case .failure(let error):
                    self?.stopDetail = nil
                    self?.error = ErrorAction(message: error.message)
                    self?.isFetching = false
                }
            }) { [weak self] detail in
                self?.stopDetail = self?.dependencies.annotationMapper.map(domain: detail)
                self?.isFetching = false
        }
        .store(in: &dependencies.cancellable)
    }

    func isStart(coordinate: CLLocationCoordinate2D) -> Bool {
        guard let selectedTrip = selectedTrip,
            trips.indices.contains(selectedTrip),
            let first = trips[selectedTrip].route.first
            else {
                return false
        }
        return first == coordinate
    }

    func isEnd(coordinate: CLLocationCoordinate2D) -> Bool {
        guard let selectedTrip = selectedTrip,
            trips.indices.contains(selectedTrip),
            let first = trips[selectedTrip].route.last
            else {
                return false
        }
        return first == coordinate
    }
}
