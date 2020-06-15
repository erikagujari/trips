//
//  TripResponse.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

// MARK: - TripResponse
public struct TripResponse: Decodable {
    let origin: DestinationResponse?
    let stops: [StopResponse]?
    let destination: DestinationResponse?
    let endTime: String?
    let startTime: String?
    let description: String?
    let driverName: String?
    let route: String?
    let status: String?
    
    public init(origin: DestinationResponse?, stops: [StopResponse]?, destination: DestinationResponse?, endTime: String?, startTime: String?, description: String?, driverName: String?, route: String?, status: String?) {
        self.origin = origin
        self.stops = stops
        self.destination = destination
        self.endTime = endTime
        self.startTime = startTime
        self.description = description
        self.driverName = driverName
        self.route = route
        self.status = status
    }
}

// MARK: - Destination
public struct DestinationResponse: Decodable {
    let address: String?
    let point: PointResponse?
    
    public init(address: String?, point: PointResponse?) {
        self.address = address
        self.point = point
    }
}

// MARK: - Point
public struct PointResponse: Decodable {
    let latitude: Double?
    let longitude: Double?

    enum CodingKeys: String, CodingKey {
        case latitude = "_latitude"
        case longitude = "_longitude"
    }
    
    public init(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Stop
public struct StopResponse: Decodable {
    let point: PointResponse?
    let id: Int?
    
    public init(point: PointResponse?, id: Int?) {
        self.point = point
        self.id = id
    }
}
