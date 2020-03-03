//
//  TripService.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

enum TripService {
    case trips
    case stops(Int)
}

extension TripService: Service {
    var baseURL: String {
        return "https://europe-west1-metropolis-fe-test.cloudfunctions.net"
    }

    var path: String {
        switch self {
        case .trips:
            return "/api/trips"
        case .stops(let id):
            return "/api/stops/\(id)"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .trips, .stops:
            return nil
        }
    }

    var method: ServiceMethod {
        switch self {
        case .trips, .stops:
            return .get
        }
    }
}

