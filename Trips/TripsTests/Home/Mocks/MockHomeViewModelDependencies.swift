//
//  MockHomeViewModelDependencies.swift
//  TripsTests
//
//  Created by AGUJARI Erik on 04/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import Combine
import Foundation
import CoreLocation
@testable import Trips

final class MockHomeViewModelDependencies: HomeViewModelDependenciesProtocol {
    var stopUseCase: RetrieveStopDetailUseCaseProtocol = MockRetrieveStopDetailUseCase()
    var cellMapper: HomeCellMapper = HomeCellMapper()
    var annotationMapper: StopAnnotationMapper = StopAnnotationMapper()
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    var tripsUseCase: RetrieveTripsUseCaseProtocol = MockRetrieveTripsUseCase()
    var mapper: HomeCellMapper = HomeCellMapper()
}

final class MockRetrieveStopDetailUseCase: RetrieveStopDetailUseCaseProtocol {
    func fetchStopDetail(id: Int) -> AnyPublisher<StopDetail, TripError> {
        return Future { promise in
            if id == 0 {
                promise(.success(StopDetail(userName: "",
                                            price: 0,
                                            stopTime: Date(),
                                            paid: false,
                                            address: "")))
            } else {
                promise(.failure(TripError.serviceError))
            }
        }
    .eraseToAnyPublisher()
    }
}

final class MockRetrieveTripsUseCase: RetrieveTripsUseCaseProtocol {
    var trips: AnyPublisher<[Trip], TripError> {
        return Future { promise in
            promise(.success([Trip(origin: Destination(address: "MockAddress1",
                                                       point: Point(latitude: 0,
                                                                    longitude: 0)),
                                   stops: [Stop(point: Point(latitude: 0,
                                                             longitude: 0),
                                                id: 0)],
                                   destination: Destination(address: "MockAddress1",
                                                            point: Point(latitude: 0,
                                                                         longitude: 0)),
                                   endTime: Date(),
                                   startTime: Date(),
                                   description: "",
                                   driverName: "MockDriver1",
                                   route: [CLLocationCoordinate2D(latitude: 0,
                                                                  longitude: 0),
                                           CLLocationCoordinate2D(latitude: 2,
                                                                  longitude: 2),
                                           CLLocationCoordinate2D(latitude: 3,
                                                                  longitude: 3)],
                                   status: "")]))
        }
        .eraseToAnyPublisher()
    }
}
