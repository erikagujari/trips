//
//  DefaultTripLoader.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

public struct DefaultTripLoader: TripLoader {
    public var tripsService: Service {
        return TripsService()
    }
    
    public func stopService(id: Int) -> Service {
        return StopService(id: id)
    }
}

public struct StopService: Service {
    public var baseURL: String = "https://europe-west1-metropolis-fe-test.cloudfunctions.net"
    public var path: String
    public var parameters: [String : Any]? = nil
    public var method: ServiceMethod = .get
    
    init(id: Int) {
        self.path = "/api/stops/\(id)"
    }
}

public struct TripsService: Service {
    public var baseURL: String = "https://europe-west1-metropolis-fe-test.cloudfunctions.net"
    public var path: String = "/api/trips"
    public var parameters: [String : Any]? = nil
    public var method: ServiceMethod = .get
}
