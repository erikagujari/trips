//
//  TripMockRepositories.swift
//  TripsTests
//
//  Created by Erik Agujari on 15/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Trips
import Combine

struct TripErrorRepository: TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        return Future { promise in
            promise(.failure(TripError.serviceError))
        }.eraseToAnyPublisher()
    }
    
    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
        return Future { promise in
            promise(.failure(TripError.serviceError))
        }.eraseToAnyPublisher()
    }
}

struct TripEmptyRepository: TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        return Future { promise in
            promise(.success([]))
        }.eraseToAnyPublisher()
    }
    
    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
        return Future { promise in
            promise(.failure(TripError.serviceError))
        }.eraseToAnyPublisher()
    }
}

struct TripInvalidRepository: TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        return Future { promise in
            let invalidStop = StopResponse(point: nil, id: nil)
            let trip = TripResponse(origin: nil,
                                    stops: [invalidStop],
                                    destination: nil,
                                    endTime: "",
                                    startTime: "",
                                    description: nil,
                                    driverName: nil,
                                    route: nil,
                                    status: nil)
            promise(.success([trip]))
        }.eraseToAnyPublisher()
    }
    
    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
        return Future { promise in
            let stopDetail = StopDetailResponse(userName: nil,
                                                point: nil,
                                                price: nil,
                                                stopTime: nil,
                                                paid: nil,
                                                address: nil,
                                                tripId: id)
            promise(.success(stopDetail))
        }.eraseToAnyPublisher()
    }
}

struct TripValidRepository: TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        return Future { promise in
            let originPoint = PointResponse(latitude: 1.0, longitude: 1.0)
            let origin = DestinationResponse(address: "", point: originPoint)
            let destinationPoint = PointResponse(latitude: 2.0, longitude: 2.0)
            let destination = DestinationResponse(address: "", point: destinationPoint)
            
            let trip = TripResponse(origin: origin,
                                    stops: nil,
                                    destination: destination,
                                    endTime: "",
                                    startTime: "",
                                    description: nil,
                                    driverName: nil,
                                    route: nil,
                                    status: nil)
            promise(.success([trip]))
        }.eraseToAnyPublisher()
    }
    
    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
        return Future { promise in
            if id < 0 {
                let stopDetail = StopDetailResponse(userName: nil,
                                                    point: nil,
                                                    price: nil,
                                                    stopTime: nil,
                                                    paid: nil,
                                                    address: nil,
                                                    tripId: id)
                promise(.success(stopDetail))
            } else {
                let stopDetail = StopDetailResponse(userName: "Bob",
                                                    point: nil,
                                                    price: nil,
                                                    stopTime: nil,
                                                    paid: nil,
                                                    address: "FakeStreet 2nd Floor",
                                                    tripId: id)
                promise(.success(stopDetail))
            }
        }.eraseToAnyPublisher()
    }
}

struct TripCompleteRepository: TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        return Future { promise in
            let originPoint = PointResponse(latitude: 1.0, longitude: 1.0)
            let origin = DestinationResponse(address: "", point: originPoint)
            let destinationPoint = PointResponse(latitude: 2.0, longitude: 2.0)
            let destination = DestinationResponse(address: "", point: destinationPoint)
            let stop = StopResponse(point: originPoint, id: 0)
            
            let trip = TripResponse(origin: origin,
                                    stops: [stop],
                                    destination: destination,
                                    endTime: "",
                                    startTime: "",
                                    description: "a description",
                                    driverName: "Fernando Alonso",
                                    route: "",
                                    status: "Running")
            promise(.success([trip]))
        }.eraseToAnyPublisher()
    }
    
    func retrieveStop(id: Int) -> AnyPublisher<StopDetailResponse, TripError> {
        return Future { promise in
            promise(.failure(TripError.serviceError))
        }.eraseToAnyPublisher()
    }
}

