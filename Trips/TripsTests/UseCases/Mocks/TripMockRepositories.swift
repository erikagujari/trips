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

struct TripInvalidRepository: TripRepositoryProtocol {
    func retrieveTrips() -> AnyPublisher<[TripResponse], TripError> {
        return Future { promise in
            promise(.failure(TripError.serviceError))
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
            promise(.failure(TripError.serviceError))
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

