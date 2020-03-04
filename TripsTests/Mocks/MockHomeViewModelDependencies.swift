//
//  MockHomeViewModelDependencies.swift
//  TripsTests
//
//  Created by AGUJARI Erik on 04/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import Combine
import Foundation
@testable import Trips

final class MockHomeViewModelDependencies: HomeViewModelDependenciesProtocol {
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    var tripsUseCase: RetrieveTripsUseCaseProtocol = MockRetrieveTripsUseCase()
    var mapper: HomeCellMapper = HomeCellMapper()
}

final class MockRetrieveTripsUseCase: RetrieveTripsUseCaseProtocol {
    var trips: AnyPublisher<[Trip], TripError> {
        return Future { promise in
            promise(.success([Trip(origin: Destination(address: "MockAddress1",
                                                       point: Point(latitude: 0,
                                                                    longitude: 0)),
                                   stops: [],
                                   destination: Destination(address: "MockAddress1",
                                                            point: Point(latitude: 0,
                                                                         longitude: 0)),
                                   endTime: Date(),
                                   startTime: Date(),
                                   description: "",
                                   driverName: "MockDriver1",
                                   route: [],
                                   status: "")]))
        }
        .eraseToAnyPublisher()
    }
}
